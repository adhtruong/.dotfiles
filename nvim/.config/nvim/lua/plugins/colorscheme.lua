return {
  {
    "catppuccin/nvim",
    enabled = false,
  },
  {
    "Mofiqul/vscode.nvim",
    priority = 100,
    config = function()
      require("vscode").setup({
        transparent = false,
        italic_comments = false,
        disable_nvimtree_bg = true,
      })
      vim.cmd([[colorscheme vscode]])
    end,
  },
}
