vim.loader.enable()

local cmd = vim.cmd
local opt = vim.o
local lsp = vim.lsp

opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.lazyredraw = true
opt.showmatch = true
opt.incsearch = true
opt.hlsearch = true

opt.spell = true
opt.spelllang = 'en'

-- Disable spellcheck in the terminal
vim.api.nvim_create_autocmd("TermOpen", { pattern = "term://*", command = "setlocal nospell" })

opt.expandtab = true
opt.tabstop = 2
opt.softtabstop = 2

opt.shiftwidth = 2
opt.history = 2000
opt.nrformats = 'bin,hex'
opt.undofile = true
opt.splitright = true
opt.splitbelow = true

opt.cmdheight = 1

opt.colorcolumn = '100'

opt.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
opt.foldenable = true
opt.foldcolumn = "1"

opt.list = true
opt.listchars = "tab:. ,leadtab:. ,leadmultispace:. ,trail:*"

opt.laststatus = 3

cmd.filetype('plugin', 'indent', 'on')

vim.g.sqlite_clib_path = require('luv').os_getenv('LIBSQLITE')

lsp.enable({
    "lua_ls",
    "nil",
    "nixd",
    "haskell-language-server",
    "rust_analyzer",
    "crates",
})

lsp.inlay_hint.enable(true)

vim.diagnostic.config({
    severity_sort = true,
    virtual_text = true,
})


if vim.g.firenvim then
    opt.guifont = "JetBrainsMonoNL Nerd Font:h18"
end

if vim.g.neovide then
    opt.guifont = "Uiua386:h11"
end
