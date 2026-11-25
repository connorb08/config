return {
  -- Colorscheme
  {
    "cpea2506/one_monokai.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("one_monokai").setup({
        italics = true,
        colors = {
          fg = "#abb2bf",
          bg = "#191c22",
          gray = "#676f7d",
          pink = "#ff505e",
          green = "#8cc761",
          cyan = "#32b8c9",
          aqua = "#4dafff",
          yellow = "#f1bd5b",
          purple = "#da61fe",
          peanut = "#f1bd5b",
          orange = "#e49346",
          dark_pink = "#ff505e",
          dark_cyan = "#32b8c9",
          red = "#ff505e",
          dark_red = "#c24038",
          white = "#d7dae0",
          light_gray = "#9da5b4",
          dark_gray = "#4e5666",
          vulcan = "#2c3340",
          dark_green = "#262c36",
          dark_blue = "#222730",
          black = "#13161b",
        },
        -- The plugin's default highlight mappings differ from the source theme.
        highlights = function(colors)
          return {
            Visual = { bg = colors.vulcan },
            CursorLine = { bg = colors.dark_green },
            CursorColumn = { bg = colors.dark_green },
            Cursor = { fg = colors.bg, bg = "#f8f8f0" },
            LineNr = { fg = "#495162" },
            NormalFloat = { fg = colors.fg, bg = colors.black },
            FloatBorder = { fg = "#0d0f12", bg = colors.black },
            PmenuSel = { fg = colors.white, bg = colors.dark_blue },
            Search = { fg = colors.fg, bg = "#344566" },
            IncSearch = { fg = colors.fg, bg = "#344566" },
            DiagnosticError = { fg = colors.dark_red },
            DiagnosticUnderlineError = { sp = colors.dark_red, undercurl = true },
            Keyword = { fg = colors.pink },
            Constant = { fg = colors.cyan },
            Identifier = { fg = colors.fg },
            Include = { fg = colors.aqua },
            Delimiter = { fg = colors.fg },
            ["@constant.builtin"] = { fg = colors.cyan },
            ["@type.builtin"] = { fg = colors.cyan },
            ["@function.call"] = { fg = colors.fg },
            ["@function.method.call"] = { fg = colors.fg },
            -- Config files: keys in the theme's JSON-property cyan (they were
            -- plain text), TOML table headers in bold class blue
            -- (after/queries/toml/highlights.scm marks them @type).
            ["@property.toml"] = { fg = colors.cyan },
            ["@property.json"] = { fg = colors.cyan },
            ["@property.yaml"] = { fg = colors.cyan },
            ["@type.toml"] = { fg = colors.aqua, bold = true },
          }
        end,
      })
    end,
  },

  -- Statusline
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    opts = {
      options = { theme = "one_monokai", globalstatus = true },
    },
  },

  -- Shows the available keys after a prefix such as <leader>
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      spec = {
        { "<leader>f", group = "find" },
        { "<leader>g", group = "git" },
        { "<leader>c", group = "code" },
      },
    },
  },
}
