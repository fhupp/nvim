local navic = require("nvim-navic")

local function load()
    navic.setup({
        lsp = {
            preference = nil,
        },

        icons = {
            enabled       = false,
            File          = "󰈙 ",
            Module        = " ",
            Namespace     = "󰌗 ",
            Package       = " ",
            Class         = "󰌗 ",
            Method        = "󰆧 ",
            Property      = " ",
            Field         = " ",
            Constructor   = " ",
            Enum          = "󰕘",
            Interface     = "󰕘",
            Function      = "󰊕 ",
            Variable      = "󰆧 ",
            Constant      = "󰏿 ",
            String        = "󰀬 ",
            Number        = "󰎠 ",
            Boolean       = "◩ ",
            Array         = "󰅪 ",
            Object        = "󰅩 ",
            Key           = "󰌋 ",
            Null          = "󰟢 ",
            EnumMember    = " ",
            Struct        = "󰌗 ",
            Event         = " ",
            Operator      = "󰆕 ",
            TypeParameter = "󰊄 ",
        },

        highlight = false,
        separator = " > ",
        click = true,
        safe_output = true,

        format_text = function(text)
            return text
        end,
    })
end

require("lze").load({
    "nvim-navic",
    event = "VimEnter",
    after = load,
})
