local navic = require("nvim-navic")

---@type vim.lsp.Config
return {
    cmd = { "rust-analyzer" },

    filetypes = { "rust" },

    root_markers = {
        ".git",
        'Cargo.toml',

    },

    on_attach = function(client, bufnr)
        navic.attach(client, bufnr)
    end,

    settings = {

    },
}
