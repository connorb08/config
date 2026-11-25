;; extends
; Table and array-of-tables headers ([tools], [[servers]], [a.b]) as @type, so
; they stand apart from ordinary keys (colours in lua/plugins/ui.lua).
(table (bare_key) @type)
(table (dotted_key (bare_key) @type))
(table (quoted_key) @type)
(table_array_element (bare_key) @type)
(table_array_element (dotted_key (bare_key) @type))
