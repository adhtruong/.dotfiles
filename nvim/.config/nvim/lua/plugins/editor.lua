return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      filesystem = {
        filtered_items = {
          visible = true,
        },
      },
    },
  },
  {
    "folke/noice.nvim",
    opts = {
      presets = {
        command_palette = true,
      },
      views = {
        cmdline_popup = {
          position = {
            row = "25%",
            col = "50%",
          },
          size = {
            width = 60,
            height = "auto",
          },
          border = {
            style = "rounded",
          },
        },
      },
    },
  },
  {
    "ibhagwan/fzf-lua",
    opts = function()
      local config = require("fzf-lua.config")
      config.defaults.keymap.fzf["ctrl-u"] = "clear-query"
      config.defaults.keymap.fzf["ctrl-w"] = "backward-kill-word"

      return {
        winopts = {
          border = "rounded",
        },
        fzf_opts = {
          ["--layout"] = "reverse",
          ["--no-separator"] = "",
        },
      }
    end,
  },
}
