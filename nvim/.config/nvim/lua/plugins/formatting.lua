return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      sh = { "shfmt" },
    },
    formatters = {
      shfmt = {
        inherit = false,
        command = "shfmt",
        args = { "-i", "0", "-filename", "$FILENAME" },
      },
    },
  },
}
