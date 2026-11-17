require('lze').load({
    "colorscheme",
    event = "VimEnter",
    before = function()
        vim.cmd.colorscheme("moonfly")
    end,
})
