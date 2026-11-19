local api = vim.api

-- Disable spellcheck in the terminal
api.nvim_create_autocmd("TermOpen", {
  pattern = "term://*",
  command = "setlocal nospell",
  desc = "Disable spell in terminal"
})
