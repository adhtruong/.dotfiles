return {
  "neovim/nvim-lspconfig",
  init = function()
    local keys = require("lazyvim.plugins.lsp.keymaps").get()
    -- Disable the K key for hover
    keys[#keys + 1] = { "K", false }
  end,
  opts = {
    inlay_hints = { enabled = false },
  },
}
