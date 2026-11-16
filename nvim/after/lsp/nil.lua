local navic = require("nvim-navic")

---@type vim.lsp.Config
return {
    cmd = { "nil" },

    filetypes = { "nix" },

    on_attach = function(client, bufnr)
        -- We get completion from nixd, and everything else from nil
        client.server_capabilities.completionProvider = nil
        navic.attach(client, bufnr)
    end,
}
