require('lze').load({
  "colorscheme",
  event = "VimEnter",
  before = function()
    vim.g.moonflyVirtualTextColor = true
    vim.g.moonflyWinSeparator = 2
    vim.cmd.colorscheme("moonfly")
  end,
})
