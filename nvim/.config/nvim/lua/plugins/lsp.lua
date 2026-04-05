vim.lsp.config("tombi", {
  cmd = { "tombi", "lsp" },
  filetypes = { "toml" },
  root_markers = { "tombi.toml", ".git" },
})
vim.lsp.enable("tombi")

return {
  "neovim/nvim-lspconfig",
  opts = function(_, opts)
    opts.inlay_hints = { enabled = false }
    opts.servers = vim.tbl_deep_extend("force", opts.servers or {}, {
      -- Disable K hover for all LSP servers
      ["*"] = {
        keys = {
          { "K", false },
        },
      },
      taplo = false,
      pyright = false,
      basedpyright = {
        settings = {
          basedpyright = {
            analysis = {
              typeCheckingMode = "standard",
            },
          },
        },
      },
    })

    return opts
  end,
}
