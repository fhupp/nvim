---@type vim.lsp.Config
return {
    cmd = { "lua-language-server" },

    filetypes = { "lua" },

    root_markers = {
        ".git",
        '.emmyrc.json',
        '.luarc.json',
        '.luarc.jsonc',
    },

    telemetry = { enabled = false },

    settings = {
        Lua = {
            codeLens = { enable = true },

            hint = { enable = true, semicolon = 'Disable' },

            diagnostics = {
              globals = {
                "vim",
              },
            },

            runtime = {
              version = "LuaJIT",
            },

            workspace = {
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file("lua", true),
            },
        },
    },
}
