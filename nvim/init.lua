vim.loader.enable()

local cmd = vim.cmd
local opt = vim.o
local lsp = vim.lsp
local api = vim.api

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.g.sqlite_clib_path = require('luv').os_getenv('LIBSQLITE')

opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.lazyredraw = true

-- Search
opt.showmatch = true
opt.incsearch = true
opt.hlsearch = true

-- Spell Check
opt.spell = true
opt.spelllang = 'en'

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

-- Fold
opt.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
opt.foldenable = true
opt.foldcolumn = "1"

-- White-space
opt.list = true
opt.listchars = "tab:. ,leadtab:. ,leadmultispace:. ,trail:*"

opt.laststatus = 3

cmd.filetype('plugin', 'indent', 'on')

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

require("config.keymap")
require("config.terminal")

if vim.g.started_by_firenvim then
  require("config.firenvim")
end

if vim.g.neovide then
  require("config.neovide")
end

-- ---@param ev vim.api.keyset.create_autocmd.callback_args
-- local function pre_save_buf(ev)
--   vim.lsp.buf.format({ async = false })
-- end
--
-- api.nvim_create_autocmd('BufWritePre', {
--   desc = "Format buffer before writing it (LSP)",
--   callback = pre_save_buf,
-- })
