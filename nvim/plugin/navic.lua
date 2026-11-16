local navic = require("nvim-navic")


local function nvc_hl(name, fg)
    vim.api.nvim_set_hl(0, name, { default = true, bg = "#080808", fg = fg })
end

local function set_hl()
    nvc_hl("NavicIconsFile", "#ffffff")
    nvc_hl("NavicIconsModule", "#ffffff")
    nvc_hl("NavicIconsNamespace", "#ffffff")
    nvc_hl("NavicIconsPackage", "#ffffff")
    nvc_hl("NavicIconsClass", "#ffffff")
    nvc_hl("NavicIconsMethod", "#ffffff")
    nvc_hl("NavicIconsProperty", "#ffffff")
    nvc_hl("NavicIconsField", "#ffffff")
    nvc_hl("NavicIconsConstructor", "#ffffff")
    nvc_hl("NavicIconsEnum", "#ffffff")
    nvc_hl("NavicIconsInterface", "#ffffff")
    nvc_hl("NavicIconsFunction", "#ffffff")
    nvc_hl("NavicIconsVariable", "#ffffff")
    nvc_hl("NavicIconsConstant", "#ffffff")
    nvc_hl("NavicIconsString", "#ffffff")
    nvc_hl("NavicIconsNumber", "#ffffff")
    nvc_hl("NavicIconsBoolean", "#ffffff")
    nvc_hl("NavicIconsArray", "#ffffff")
    nvc_hl("NavicIconsObject", "#ffffff")
    nvc_hl("NavicIconsKey", "#ffffff")
    nvc_hl("NavicIconsNull", "#ffffff")
    nvc_hl("NavicIconsEnumMember", "#ffffff")
    nvc_hl("NavicIconsStruct", "#ffffff")
    nvc_hl("NavicIconsEvent", "#ffffff")
    nvc_hl("NavicIconsOperator", "#ffffff")
    nvc_hl("NavicIconsTypeParameter", "#ffffff")
    nvc_hl("NavicText", "#ffffff")
    nvc_hl("NavicSeparator", "#ffffff")
end

local function load()
    navic.setup({
        highlight = true,

        lsp = {
            preference = nil,
        },

        icons = {
            enabled = false,
        },
        seperator = " :: ",
        safe_output = true,

        format_text = function(text)
            return text
        end,
    })
end

require("lze").load({
    "nvim-navic",
    event = "VimEnter",
    before = set_hl,
    after = load,
    dep_of = "lualine.nvim",
})
