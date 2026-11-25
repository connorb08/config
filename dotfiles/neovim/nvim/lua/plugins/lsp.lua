return {
  -- Language servers. mason installs them into Neovim's data directory;
  -- every server installed with :Mason is enabled automatically.
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "neovim/nvim-lspconfig",
    },
    event = { "BufReadPre", "BufNewFile" },
    cmd = { "Mason", "MasonInstall", "MasonUpdate", "LspInstall" },
    opts = {
      ensure_installed = { "lua_ls" },
    },
    config = function(_, opts)
      require("mason-lspconfig").setup(opts)

      -- Servers that are already on PATH and need no mason package.
      if vim.fn.executable("nu") == 1 then
        vim.lsp.enable("nushell")
      end

      vim.diagnostic.config({
        severity_sort = true,
        virtual_text = { spacing = 2, source = "if_many" },
        float = { border = "rounded", source = "if_many" },
      })

      -- Neovim's own defaults cover the rest: K hover, grn rename,
      -- gra code action, grr references, gri implementation, gO symbols.
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(event)
          local function map(lhs, rhs, desc)
            vim.keymap.set("n", lhs, rhs, { buffer = event.buf, desc = desc })
          end
          map("gd", vim.lsp.buf.definition, "Go to definition")
          map("gD", vim.lsp.buf.declaration, "Go to declaration")
          map("<leader>cr", vim.lsp.buf.rename, "Rename symbol")
          map("<leader>ca", vim.lsp.buf.code_action, "Code action")
          map("<leader>cf", function() vim.lsp.buf.format({ async = true }) end, "Format buffer")
          map("<leader>cd", vim.diagnostic.open_float, "Line diagnostics")
        end,
      })
    end,
  },

  -- Completion
  {
    "saghen/blink.cmp",
    version = "1.*",
    event = "InsertEnter",
    opts = {
      keymap = { preset = "default" },
      completion = { documentation = { auto_show = true } },
      signature = { enabled = true },
    },
  },

  -- Makes lua_ls understand the Neovim API when editing this config
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
}
