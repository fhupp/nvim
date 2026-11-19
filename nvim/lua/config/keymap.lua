local wk = require("which-key")

local function format_buf()
  vim.lsp.buf.format({ async = true, })
end

local function window_manager()
  require("which-key").show({
    keys = "<c-w>",
    loop = true, -- this will keep the popup open until you hit <esc>
  })
end

wk.add(
---@type wk.Spec
  {
    { "<leader>f",  group = "file" },
    { "<leader>ff", format_buf,               desc = "Format Buffer (LSP)", mode = "n" },
    { "<leader>fc", "q",                      desc = "File Close",          mode = "n" },
    { "<leader>fw", "w",                      desc = "File Write",          mode = "n" },

    { "<leader>l",  group = "lsp" },
    { "<leader>lf", format_buf,               desc = "Format Buffer (LSP)", mode = "n" },
    { "<leader>lr", "<cmd>lsp restart<cmod>", desc = "Restart LSP",         mode = "n" },

    { "<leader>w",  window_manager }
  })
