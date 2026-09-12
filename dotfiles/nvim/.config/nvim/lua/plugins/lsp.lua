-- LSP configuration using Neovim's native vim.lsp.enable() / vim.lsp.config()
-- (0.11+), not nvim-lspconfig's older setup{} framework. nvim-lspconfig is
-- kept only as a data-only dependency: it ships the default lsp/<name>.lua
-- configs on its runtimepath, which vim.lsp.enable() picks up automatically.
--
-- If a server ever needs an override (extra settings, custom cmd, etc.), add
-- a sibling lsp/<name>.lua file directly under .config/nvim/ (i.e. next to
-- lua/, not inside it) -- Neovim's native runtimepath resolution merges it
-- with nvim-lspconfig's default automatically. None of the servers below
-- need one: every installed binary matches nvim-lspconfig's defaults
-- exactly.
--
-- All servers here are installed system-wide via pacman/paru, not
-- mason.nvim -- this project installs tooling repo -> AUR -> user-install,
-- consistent with the rest of this dotfiles repo.
return {
  "neovim/nvim-lspconfig",
  lazy = false,
  config = function()
    vim.lsp.enable({
      "lua_ls",
      "bashls",
      "basedpyright",
      "ruff",
      "rust_analyzer",
      "gopls",
      "vtsls",
      "jsonls",
      "yamlls",
      "dockerls",
      "marksman",
    })

    vim.diagnostic.config({
      virtual_text = { spacing = 4, prefix = "●" },
      severity_sort = true,
      float = { border = "rounded" },
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = "",
          [vim.diagnostic.severity.WARN] = "",
          [vim.diagnostic.severity.INFO] = "",
          [vim.diagnostic.severity.HINT] = "",
        },
      },
    })

    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("xcloud-lsp-attach", { clear = true }),
      desc = "Buffer-local LSP keymaps",
      callback = function(args)
        local map = function(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = args.buf, desc = desc })
        end

        map("n", "gd", vim.lsp.buf.definition, "Goto definition")
        map("n", "gD", vim.lsp.buf.declaration, "Goto declaration")
        map("n", "gi", vim.lsp.buf.implementation, "Goto implementation")
        map("n", "gr", vim.lsp.buf.references, "Goto references")
        map("n", "K", vim.lsp.buf.hover, "Hover documentation")
        map("n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")
        map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code action")
        map("n", "<leader>D", vim.lsp.buf.type_definition, "Type definition")
        map("n", "<leader>e", vim.diagnostic.open_float, "Show line diagnostics")
        map("n", "[d", function()
          vim.diagnostic.jump({ count = -1, float = true })
        end, "Previous diagnostic")
        map("n", "]d", function()
          vim.diagnostic.jump({ count = 1, float = true })
        end, "Next diagnostic")
      end,
    })
  end,
}
