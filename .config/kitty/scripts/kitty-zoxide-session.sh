#!/usr/bin/env bash

# ~/.config/kitty/scripts/kitty-zoxide-session.sh
# Select a zoxide entry and switch to an existing kitty session,
# or create it if it doesn't exist.
#
# Also supports SSH host entries from ~/.ssh/config (and Include files).
# SSH entries are shown with a "ssh-" prefix to make them easy to filter
# and are treated as SSH targets (not zoxide directories).

set -euo pipefail

# kitty keybinds run with a minimal GUI PATH; make sure homebrew is on it
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

kitty_bin="/Applications/kitty.app/Contents/MacOS/kitty"

require_cmd() {
  local cmd="$1"
  local install_hint="$2"
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "$cmd is not installed or not in PATH."
    echo "$install_hint"
    exit 1
  fi
}

require_cmd fzf "Install (brew): brew install fzf"
require_cmd jq "Install (brew): brew install jq"
require_cmd zoxide "Install (brew): brew install zoxide"

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

normalize_path() {
  local p="$1"
  if command -v realpath >/dev/null 2>&1; then
    realpath "$p"
    return 0
  fi

  if command -v python3 >/dev/null 2>&1; then
    python3 - "$p" <<'PY'
import os
import sys
print(os.path.realpath(sys.argv[1]))
PY
    return 0
  fi

  if command -v python >/dev/null 2>&1; then
    python - "$p" <<'PY'
import os
import sys
print(os.path.realpath(sys.argv[1]))
PY
    return 0
  fi

  printf "%s" "$p"
}

hash_path() {
  local p="$1"
  if command -v shasum >/dev/null 2>&1; then
    printf "%s" "$p" | shasum -a 256 | awk '{print $1}'
    return 0
  fi

  if command -v md5 >/dev/null 2>&1; then
    printf "%s" "$p" | md5
    return 0
  fi

  if command -v python3 >/dev/null 2>&1; then
    python3 - "$p" <<'PY'
import hashlib
import sys
print(hashlib.sha256(sys.argv[1].encode("utf-8")).hexdigest())
PY
    return 0
  fi

  if command -v python >/dev/null 2>&1; then
    python - "$p" <<'PY'
import hashlib
import sys
print(hashlib.sha256(sys.argv[1].encode("utf-8")).hexdigest())
PY
    return 0
  fi

  printf "%s" "$p"
}

session_exists() {
  local name="$1"
  "$kitty_bin" @ --to "${sock}" ls 2>/dev/null | jq -e --arg name "$name" '
    any(.[]?.tabs[]?.windows[]?; .session_name == $name)
  ' >/dev/null
}

bump_zoxide_score() {
  local path="$1"
  zoxide add -- "$path" >/dev/null 2>&1 || true
}

find_session_by_path() {
  local target="$1"
  local name=""
  local pwd=""
  local real=""

  while IFS=$'\t' read -r name pwd; do
    [[ -z "$name" || -z "$pwd" ]] && continue
    [[ ! -d "$pwd" ]] && continue
    real="$(normalize_path "$pwd")"
    if [[ "$real" == "$target" ]]; then
      printf "%s" "$name"
      return 0
    fi
  done < <(
    "$kitty_bin" @ --to "${sock}" ls 2>/dev/null | jq -r '
      .[]?.tabs[]?.windows[]?
      | select(.session_name != null and .session_name != "")
      | [(.session_name|tostring), (.env.PWD // .cwd // "")]
      | @tsv
    '
  )

  return 1
}

print_menu_lines() {
  zoxide query -l 2>/dev/null | awk -v OFS='\t' '{
    path=$0
    n=split(path, parts, "/")
    base=parts[n]
    if (base == "") base=path
    printf "%s\t%s  %s\n", path, base, path
  }'

  # SSH entries are not zoxide paths: they are parsed from ~/.ssh/config
  # (including Include files) and displayed with a ssh- prefix.
  print_ssh_menu_lines
}

collect_ssh_config_files() {
  local root_config="$HOME/.ssh/config"
  local file=""
  local line=""
  local includes=""
  local pattern=""
  local match=""
  local queue=()
  local files=()
  local pats=()
  local processed="|"
  local old_nullglob=""

  if [[ ! -f "$root_config" ]]; then
    return 0
  fi

  queue+=("$root_config")

  old_nullglob="$(shopt -p nullglob || true)"
  shopt -s nullglob

  while ((${#queue[@]})); do
    file="${queue[0]}"
    queue=("${queue[@]:1}")

    case "$processed" in
    *"|${file}|"*)
      continue
      ;;
    esac

    processed+="${file}|"
    if [[ ! -f "$file" ]]; then
      continue
    fi

    files+=("$file")

    while IFS= read -r line || [[ -n "$line" ]]; do
      line="${line%%#*}"
      if [[ "$line" =~ ^[[:space:]]*Include[[:space:]]+(.+) ]]; then
        includes="${BASH_REMATCH[1]}"
        # Split into words first and expand a leading ~ per pattern: with
        # nullglob set, glob expansion would otherwise discard "~" patterns
        # before the tilde ever gets replaced.
        read -ra pats <<< "$includes"
        for pattern in "${pats[@]/#~/$HOME}"; do
          for match in $pattern; do
            if [[ -f "$match" ]]; then
              queue+=("$match")
            fi
          done
        done
      fi
    done <"$file"
  done

  eval "$old_nullglob"

  if ((${#files[@]})); then
    printf "%s\n" "${files[@]}"
  fi
}

print_ssh_menu_lines() {
  local config_files=()
  local host=""
  local label=""

  while IFS= read -r host; do
    config_files+=("$host")
  done < <(collect_ssh_config_files)

  if ((${#config_files[@]} == 0)); then
    return 0
  fi

  # Extract only concrete host names (no wildcards or negations).
  while IFS= read -r host; do
    [[ -z "$host" ]] && continue
    label="ssh-${host}"
    printf "%s\t%s\n" "ssh:${host}" "$label"
  done < <(
    awk '
      {
        sub(/[ \t]*#.*/, "")
        if (tolower($1) == "host") {
          for (i = 2; i <= NF; i++) {
            h = $i
            if (h ~ /^[!]/) continue
            if (h ~ /[\\*?]/) continue
            print h
          }
        }
      }
    ' "${config_files[@]}" | sort -u
  )
}

focus_or_launch_dir() {
  local selected_path="$1"
  local selected_real=""
  local base=""
  local safe_base=""
  local hash=""
  local short_name=""
  local session_name=""
  local existing_session=""
  local session_dir="/tmp/kitty-zoxide-sessions"
  local session_file=""

  if [[ ! -d "$selected_path" ]]; then
    echo "Directory not found: $selected_path"
    exit 1
  fi

  selected_real="$(normalize_path "$selected_path")"

  existing_session="$(find_session_by_path "$selected_real" || true)"
  if [[ -n "$existing_session" ]]; then
    bump_zoxide_score "$selected_real"
    "$kitty_bin" @ --to "${sock}" action goto_session "$existing_session"
    return 0
  fi

  base="$(basename "$selected_path")"
  safe_base="$(printf "%s" "$base" | tr -cs 'A-Za-z0-9._-' '_')"
  hash="$(hash_path "$selected_real")"
  hash="${hash:0:4}"
  short_name="z-${safe_base}"
  session_name="$short_name"
  if session_exists "$short_name"; then
    session_name="${short_name}-${hash}"
  fi

  mkdir -p "$session_dir"
  session_file="${session_dir}/${session_name}.kitty-session"

  cat >"$session_file" <<EOF
layout tall
cd ${selected_real}
launch --title "${base}"
focus
focus_os_window
EOF

  "$kitty_bin" @ --to "${sock}" action goto_session "$session_file"
  bump_zoxide_score "$selected_real"
}

focus_or_launch_ssh() {
  local host="$1"
  local safe_host=""
  local session_dir="/tmp/kitty-zoxide-sessions"
  local session_file=""

  safe_host="$(printf "%s" "$host" | tr -cs 'A-Za-z0-9._-' '_')"

  mkdir -p "$session_dir"
  session_file="${session_dir}/ssh-${safe_host}.kitty-session"

  # SSH sessions intentionally skip zoxide path logic and just run ssh <host>.
  cat >"$session_file" <<EOF
layout tall
launch --title "ssh-${host}" ssh ${host}
focus
focus_os_window
EOF

  "$kitty_bin" @ --to "${sock}" action goto_session "$session_file"
}

set +e
sel="$(
  print_menu_lines | fzf --exact --height=20 --reverse \
    --header="Type to filter, enter open, esc quit" \
    --prompt="Create New Kitty Session (zoxide + ssh) > " \
    --no-multi \
    --with-nth=2.. \
    --no-sort \
    --tiebreak=index
)"
fzf_rc=$?
set -e

# esc / abort -> nothing to do
if [[ $fzf_rc -ne 0 ]]; then
  exit 0
fi

selected_path=""
if [[ -n "${sel:-}" ]]; then
  selected_path="$(printf "%s" "$sel" | awk -F'\t' '{print $1}')"
fi

if [[ -z "${selected_path:-}" ]]; then
  exit 0
fi

if [[ "$selected_path" == ssh:* ]]; then
  focus_or_launch_ssh "${selected_path#ssh:}"
else
  focus_or_launch_dir "$selected_path"
fi
