return {
  "neovim/nvim-lspconfig",
  opts = {
    inlay_hints = { enabled = false },
    servers = {
      pyright = false,
      basedpyright = {
        settings = {
          basedpyright = {
            analysis = {
              typeCheckingMode = "standard",
            },
          },
        },
        keys = {
          -- Disable the K key for hover
          { "K", false },
        },
      },
    },
  },
}
