from kittens.tui.handler import result_handler


def main(args):
    pass


@result_handler(no_ui=True)
def handle_result(args, result, target_window_id, boss):
    window = boss.window_id_map.get(target_window_id)
    if window is None:
        return

    try:
        # Restrict "last tab" to the current kitty session so C-a space does
        # not jump across sessions. Fall back to the global recent tab for
        # windows that were not created in a named session.
        session_name = getattr(window, "created_in_session_name", "") or ""
        if not session_name:
            boss.call_remote_control(window, ("focus-tab", "--match=recent:1"))
            return

        current_tab = getattr(window, "tab", None)
        if current_tab is None and hasattr(window, "tabref"):
            current_tab = window.tabref()

        target_tab = None
        target_last_focused = -1
        for tab in boss.all_tabs:
            if tab is current_tab:
                continue
            windows = getattr(tab, "windows", None)
            if not windows:
                continue
            # A tab belongs to the current session if any of its windows do.
            if not any(
                getattr(w, "created_in_session_name", "") == session_name
                for w in windows
            ):
                continue
            # Use the most recent focus time among the tab's windows.
            last_focused = max(
                getattr(w, "last_focused_at", 0) or 0 for w in windows
            )
            if last_focused > target_last_focused:
                target_last_focused = last_focused
                target_tab = tab

        if target_tab is None:
            return

        target_tab.make_active()
    except Exception:
        pass
