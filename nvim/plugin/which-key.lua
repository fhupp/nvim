local wk = require("which-key")

require("lze").load({
  "which-key.nvim",
  event = "VimEnter",
  before = function()
    vim.api.nvim_set_hl(0, "WhichKeyNormal", {})
    vim.api.nvim_set_hl(0, "WhichKeyBorder", { fg = "#bdbdbd" })

    wk.setup(
    ---@type wk.Opts
      {
        delay = 300,
        preset = "helix",

        layout = {
          width = { max = 25 }, -- min and max width of the columns
          spacing = 2,          -- spacing between columns
        },

        ---@type wk.Win.opts
        win = {
          no_overlap = true,
          border = "single",
          padding = { 1, 1 },
          style = "minimal",
          title_pos = "center",
        },

        icons = {
          breadcrumb = ">",
          separator = "->",
          mappings = false,
          colors = false,
        },
      })
  end
})
