vim.loader.enable()

local cmd = vim.cmd
local opt = vim.o

opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.lazyredraw = true
opt.showmatch = true
opt.incsearch = true
opt.hlsearch = true

opt.spell = true
opt.spelllang = 'en'

opt.expandtab = true
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.foldenable = true
opt.history = 2000
opt.nrformats = 'bin,hex'
opt.undofile = true
opt.splitright = true
opt.splitbelow = true
opt.cmdheight = 0

opt.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
opt.colorcolumn = '100'

opt.laststatus = 3

vim.diagnostic.config({ virtual_text = true })

cmd.filetype('plugin', 'indent', 'on')

vim.g.sqlite_clib_path = require('luv').os_getenv('LIBSQLITE')

if vim.g.firenvim then
  vim.opt.gui_font = "Hack Nerd Font"
end

vim.lsp.enable({
    "lua_ls",
    "nil",
    "nixd",
    "haskell-language-server",
    "crates",
})

-- TODO: Add Neovide Config
