---@type vim.lsp.Config
return {
    cmd = { "rust-analyzer" },

    filetypes = { "rust" },

    root_markers = {
        ".git",
        'Cargo.toml',

    },

    settings = {

    },
}
