-- Syntax highlighting and indentation from tree-sitter parsers.
--
-- This is the `main` branch of nvim-treesitter, the one for Neovim 0.12 and
-- later (`master` is frozen at 0.11). It compiles parsers on this machine, so
-- it needs the `tree-sitter` CLI, which mise installs, and a C compiler.
return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      local treesitter = require("nvim-treesitter")

      -- Installed up front; a no-op once they are present.
      treesitter.install({
        "lua", "vim", "vimdoc", "query", "javascript", "python", "nu",
        "bash", "fish", "json", "yaml", "toml", "markdown", "markdown_inline",
        "diff", "gitcommit", "regex",
      })

      local function start(buffer, language)
        if not vim.api.nvim_buf_is_valid(buffer) then
          return
        end
        if pcall(vim.treesitter.start, buffer, language) then
          vim.bo[buffer].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end

      -- Enable it for every filetype that has a parser, and install the
      -- parser the first time a file of a new language is opened.
      local available = treesitter.get_available()
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(event)
          local language = vim.treesitter.language.get_lang(event.match)
          if not language then
            return
          end
          if vim.treesitter.language.add(language) then
            start(event.buf, language)
          elseif vim.tbl_contains(available, language) then
            treesitter.install(language):await(function()
              vim.schedule(function()
                start(event.buf, language)
              end)
            end)
          end
        end,
      })
    end,
  },
}
