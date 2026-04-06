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

    opts.servers = opts.servers or {}
    opts.servers["*"] = opts.servers["*"] or {}
    opts.servers["*"].keys = opts.servers["*"].keys or {}
    table.insert(opts.servers["*"].keys, { "K", false })

    opts.servers = vim.tbl_deep_extend("force", opts.servers, {
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
