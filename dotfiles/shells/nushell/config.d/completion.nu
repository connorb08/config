$env.config.completions.algorithm = "fuzzy"
$env.config.completions.case_sensitive = false
# One Tab opens the menu. With `partial` on, the first Tab only inserted the
# prefix shared by every match; fuzzy matches rarely share one, so the line
# jumped and the menu needed a second Tab.
$env.config.completions.partial = false
# A single match is inserted straight away.
$env.config.completions.quick = true
$env.config.highlight_resolved_externals = true

# Completion menu as a list with each candidate's description beside it
# (carapace supplies them for flags and subcommands), in One Monokai Darker.
# Tab / Shift-Tab move through it, Enter accepts, Esc closes.
$env.config.menus = ($env.config.menus | where name != completion_menu | append {
    name: completion_menu
    only_buffer_difference: false
    marker: "| "
    type: {
        layout: ide
        min_completion_width: 0
        max_completion_width: 50
        max_completion_height: 12
        padding: 0
        border: true
        cursor_offset: 0
        description_mode: "prefer_right"
        min_description_width: 0
        max_description_width: 60
        max_description_height: 12
        description_offset: 1
        correct_cursor_pos: false
    }
    style: {
        text: "#abb2bf"
        selected_text: { fg: "#191c22", bg: "#32b8c9", attr: b }
        description_text: "#676f7d"
        match_text: { fg: "#f1bd5b", attr: u }
        selected_match_text: { fg: "#191c22", bg: "#32b8c9", attr: bu }
    }
})
