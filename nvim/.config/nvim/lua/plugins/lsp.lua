return {
  "neovim/nvim-lspconfig",
  opts = {
    inlay_hints = { enabled = false },
    servers = {
      -- Disable K hover for all LSP servers
      ["*"] = {
        keys = {
          { "K", false },
        },
      },
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
    },
  },
}
