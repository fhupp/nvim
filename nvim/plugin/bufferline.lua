local bufferline = require("bufferline")

local function load()
    bufferline.setup({
        options = {
            mode = "buffers",
            style_preset = {
                bufferline.style_preset.no_italic,
                bufferline.style_preset.minimal,
            },
            themable = true,
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
                }
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
