return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      sh = { "shfmt" },

      ["javascript"] = { "biome-check" },
      ["javascriptreact"] = { "biome-check" },
      ["typescript"] = { "biome-check" },
      ["typescriptreact"] = { "biome-check" },
      ["json"] = { "biome-check" },
      ["css"] = { "biome-check" },

      ["python"] = { "ruff_format", "ruff_organize_imports" },
      ["lua"] = { "stylua" },
      ["markdown"] = { "prettier" },
      ["yaml"] = { "prettier" },
      ["toml"] = { "taplo" },
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
