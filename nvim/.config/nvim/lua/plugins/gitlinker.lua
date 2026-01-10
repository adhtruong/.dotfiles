return {
  "linrongbin16/gitlinker.nvim",
  cmd = "GitLink",
  keys = {
    { "<leader>gx", "<cmd>GitLink! current_branch<cr>", mode = { "n", "v" }, desc = "Open in git origin" },
    { "<leader>gX", "<cmd>GitLink current_branch<cr>", mode = { "n", "v" }, desc = "Copy git link" },
  },
}
