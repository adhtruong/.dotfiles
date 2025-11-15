return {
  {
    "nvim-telescope/telescope.nvim",
    opts = {
      defaults = {
        -- Use ripgrep for vimgrep_arguments
        vimgrep_arguments = {
          "rg",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
          "--hidden",
          "--glob=!.git/",
        },
      },
      pickers = {
        find_files = {
          -- Use ripgrep for file finding as well
          find_command = { "rg", "--files", "--hidden", "--glob", "!.git/" },
        },
      },
    },
  },
}
