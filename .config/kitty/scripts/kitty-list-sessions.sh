#!/usr/bin/env bash

# Shows open kitty sessions in fzf and switches using goto_session
# Adds a vim-like "mode":
# - Normal mode (default): j/k move, d closes, enter opens, i enters insert mode, esc quits
# - Insert mode: type to filter, enter opens, esc returns to normal mode

set -euo pipefail

# kitty keybinds run with a minimal GUI PATH; make sure homebrew is on it
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

default_mode="insert"

set_cursor_block() {
  # DECSCUSR: steady block
  printf '\e[2 q' >/dev/tty
}

set_cursor_bar() {
  # DECSCUSR: steady bar
  printf '\e[6 q' >/dev/tty
}

# Always restore cursor on exit (block, matching cursor_shape in kitty.conf)
trap 'set_cursor_block' EXIT

kitty_bin="/Applications/kitty.app/Contents/MacOS/kitty"

# Requirements
if ! command -v fzf >/dev/null 2>&1; then
  echo "fzf is not installed or not in PATH."
  echo "Install (brew): brew install fzf"
  exit 1
fi

if ! command -v jq >/dev/null 2>&1; then
  echo "jq is not installed or not in PATH."
  echo "Install (brew): brew install jq"
  exit 1
fi

if [[ ! -x "$kitty_bin" ]]; then
  echo "kitty binary not found at: $kitty_bin"
  exit 1
fi

# Prefer KITTY_LISTEN_ON (set by kitty), else fall back to the newest /tmp/kitty-* socket
sock="${KITTY_LISTEN_ON:-}"
if [[ -z "$sock" ]]; then
  latest_sock="$(ls -t /tmp/kitty-* 2>/dev/null | head -n1 || true)"
  if [[ -n "$latest_sock" && -S "$latest_sock" ]]; then
    sock="unix:${latest_sock}"
  fi
fi
if [[ -z "$sock" ]] || ! "$kitty_bin" @ --to "$sock" ls >/dev/null 2>&1; then
  echo "No kitty socket found (kitty not running, or remote control not available)."
  exit 1
fi

build_menu_lines() {
  local sessions_tsv=""
  sessions_tsv="$(
    "$kitty_bin" @ --to "${sock}" ls 2>/dev/null | jq -r '
      [
        .[] as $os
        | $os.tabs[] as $tab
        | $tab.windows[]?
        | select(.session_name != null and .session_name != "")
          | {
              session_name: .session_name,
              pwd: (.env.PWD // .cwd),
              os_focused: ($os.is_focused // false),
              tab_focused: ($tab.is_focused // false),
              last_focused_at: (.last_focused_at // 0)
            }
        ]
      # Sort sessions by recency using Kitty-provided window last_focused_at
      # See: https://github.com/kovidgoyal/kitty/issues/9799
      | sort_by(.session_name)
      | group_by(.session_name)
      | map({
          session_last_focused_at: (map(.last_focused_at) | max),
          pick: (
            if (map(.os_focused and .tab_focused) | any) then
              (map(select(.os_focused and .tab_focused)) | .[0])
            else
              .[0]
            end
          )
        })
      | map(.pick + {session_last_focused_at: .session_last_focused_at})
      # Most recent sessions first, then name for stable ordering
      | sort_by(-.session_last_focused_at, .session_name)
        | .[]
        | [(.session_name|tostring), (.os_focused|tostring), (.tab_focused|tostring), (.pwd|tostring)]
        | @tsv
    '
  )"

  if [[ -z "${sessions_tsv:-}" ]]; then
    return 1
  fi

  # idx<TAB>session_name<TAB>pretty_display ("*" marks the current session)
  printf "%s\n" "$sessions_tsv" | awk -F'\t' -v home="${HOME}" '{
    session_name=$1
    os_focused=$2
    tab_focused=$3
    path=$4
    if (home != "" && index(path, home) == 1) {
      path = "~" substr(path, length(home) + 1)
    }
    idx=NR
    current=(os_focused == "true" && tab_focused == "true") ? "*" : " "
    printf "%d\t%s\t%s %s  %s\n", idx, session_name, current, session_name, path
  }'
}

# Set the startup mode
mode="$default_mode"
fzf_start_pos=""

while true; do
  menu_lines="$(build_menu_lines || true)"
  if [[ -z "${menu_lines:-}" ]]; then
    echo "No sessions found."
    exit 1
  fi

  fzf_out=""
  fzf_rc=0

  if [[ "$mode" == "normal" ]]; then
    # Normal mode:
    # - Search disabled (typing doesn't filter)
    # - j/k move
    # - d closes session
    # - enter opens session
    # - i enters insert mode
    # - esc quits
    # - --no-clear avoids a visible screen "flash"
    #   - We exit one fzf instance and immediately start another when switching modes
    #   - Prevents fzf from clearing/restoring the screen on exit
    set_cursor_block
    set +e
    fzf_start_pos_opt=()
    if [[ -n "${fzf_start_pos:-}" && "$fzf_start_pos" -gt 1 ]]; then
      fzf_start_action="down"
      for ((i = 3; i <= fzf_start_pos; i++)); do
        fzf_start_action+="+down"
      done
      # Workaround for older fzf where start:* actions are ignored.
      # Based on https://github.com/junegunn/fzf/issues/4559
      fzf_start_pos_opt=(--bind "result:${fzf_start_action}")
    fi
    fzf_out="$(
      printf "%s\n" "$menu_lines" |
        fzf --height=100% --reverse \
          --header="Normal: j/k move, d close, enter open, i insert, esc quit" \
          --prompt="List Open Kitty Sessions > " \
          --no-multi --disabled \
          --with-nth=3.. \
          --expect=enter,d,i,esc \
          --bind 'j:down,k:up' \
          --bind 'enter:accept,d:accept,i:accept' \
          --bind 'esc:abort' \
          --no-clear \
          ${fzf_start_pos_opt[@]+"${fzf_start_pos_opt[@]}"}

    )"
    fzf_rc=$?
    fzf_start_pos=""
    set -e
  else
    # Insert mode:
    # - Search enabled (type to filter)
    # - enter opens session
    # - esc returns to normal mode
    # - --no-clear avoids a visible screen "flash"
    #   - We exit one fzf instance and immediately start another when switching modes
    #   - Prevents fzf from clearing/restoring the screen on exit

    set_cursor_bar
    set +e
    fzf_out="$(
      printf "%s\n" "$menu_lines" |
        fzf --height=100% --reverse \
          --header="Insert: type to filter, enter open, esc normal" \
          --prompt="List Open Kitty Sessions > " \
          --no-multi \
          --with-nth=3.. \
          --expect=enter,esc \
          --bind 'enter:accept' \
          --bind 'esc:abort' \
          --no-clear
    )"
    fzf_rc=$?
    set -e
  fi

  # If fzf aborted and gave no output, treat it like "esc"
  if [[ $fzf_rc -ne 0 && -z "${fzf_out:-}" ]]; then
    key="esc"
    sel=""
  else
    key="$(printf "%s\n" "$fzf_out" | head -n1)"
    sel="$(printf "%s\n" "$fzf_out" | sed -n '2p' || true)"
  fi

  # Selection line is: idx<TAB>session_name<TAB>pretty_display
  selected_title=""
  selected_index=""
  if [[ -n "${sel:-}" ]]; then
    selected_index="$(printf "%s" "$sel" | awk -F'\t' '{print $1}')"
    selected_title="$(printf "%s" "$sel" | awk -F'\t' '{print $2}')"
  fi

  if [[ "$mode" == "insert" && "$key" == "esc" ]]; then
    mode="normal"
    continue
  fi

  if [[ "$mode" == "normal" && "$key" == "esc" ]]; then
    exit 0
  fi

  if [[ "$mode" == "normal" && "$key" == "i" ]]; then
    mode="insert"
    continue
  fi

  if [[ -z "${selected_title:-}" ]]; then
    # Nothing selected (likely esc)
    if [[ "$mode" == "normal" ]]; then
      exit 0
    fi
    mode="normal"
    continue
  fi

  if [[ "$mode" == "normal" && "$key" == "d" ]]; then
    if [[ "${selected_index:-}" =~ ^[0-9]+$ ]]; then
      total_lines="$(printf "%s\n" "$menu_lines" | awk 'END{print NR}')"
      if [[ -n "${total_lines:-}" && "$selected_index" -ge "$total_lines" ]]; then
        fzf_start_pos=$((selected_index - 1))
      else
        fzf_start_pos=$selected_index
      fi
      if [[ "$fzf_start_pos" -lt 1 ]]; then
        fzf_start_pos=1
      fi
    fi
    "$kitty_bin" @ --to "${sock}" action close_session "$selected_title" >/dev/null 2>&1 || true
    continue
  fi

  if [[ "$key" == "enter" ]]; then
    "$kitty_bin" @ --to "${sock}" action goto_session "$selected_title"
    exit 0
  fi

  # Fallback behavior:
  # - In insert mode, abort returns here -> go back to normal
  # - In normal mode, unknown key -> exit
  if [[ "$mode" == "insert" ]]; then
    mode="normal"
    continue
  fi

  exit 0
done
