local bufferline = require("bufferline")

local function load()
  bufferline.setup({
    options = {
      mode = "buffers",

      style_preset = {
        bufferline.style_preset.minimal,
        bufferline.style_preset.no_italic,
      },

      themable = false,

      indicator = {
        style = "none",
      },

      numbers = "buffer_id",

      offsets = {
        {
          filetype = "neo-tree",
          text = "File Explorer",
          highlight = "Directory",
          separator = true,
        },
      },

      separator_style = "thin",

      hover = {
        enabled = true,
        delay = 200,
        reveal = { 'close' }
      },
    },
  })
end

require("lze").load({
  "bufferline.nvim",
  event = "VimEnter",
  after = function()
    vim.schedule(load)
  end
})
