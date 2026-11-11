local alpha = require("alpha")
local utils = require("alpha.utils")

local alphaleader = "m"

local file_icons = {
    enabled = true,
    highlight = true,
    provider = "devicons",
}

local header_text = {
    " Neo                 ",
    "  VIsual extended ed ",
    "   iMproved          ",
}
if vim.g.neovide then
    header_text = {
        " NEO         ",
        "    VIsual   ",
        " extenDed ed ",
        " improvEd    ",
    }
end

local header = {
    type = "text",

    opts = {
        hl = "Type",
        position = "center",
    },

    val = header_text,
}

--- @param label string
local function menu_button(label, cmd, shortcut)
    return {
        type = "button",
        val = label,
        on_press = function() vim.cmd(cmd) end,
        opts = {
            shortcut = shortcut,
            keymap = {
                "n",
                shortcut,
                "<cmd>" .. cmd .. "<cr>",
                {
                    noremap = true,
                    silent = true,
                    nowait = true,
                }
            },

            position = "center",
            cursor = 3,
            width = 60,

            align_shortcut = "right",
            hl_shortcut = "Function",

            shrink_margin = false,
        },
    }
end

local mru_opts = {
    ignore = function(path, ext)
        return (string.find(path, "COMMIT_EDITMSG")) or (vim.tbl_contains({ "gitcommit" }, ext))
    end,
    autocd = false
}

--- @param sc string
--- @param txt string
--- @param keybind string? optional
--- @param keybind_opts table? optional
local function button(sc, txt, keybind, keybind_opts)
    local short = sc:gsub("%s", ""):gsub("<alphaleader>", alphaleader)

    local opts = {
        position = "center",
        shortcut = sc:gsub("<alphaleader>", alphaleader),
        cursor = 3,
        width = 60,
        align_shortcut = "right",
        hl_shortcut = "Function",
        shrink_margin = false,
    }
    if keybind then
        keybind_opts = keybind_opts or { noremap = true, silent = true, nowait = true }
        opts.keymap = { "n", short, keybind, keybind_opts }
    end

    local function on_press()
        local key = vim.api.nvim_replace_termcodes(keybind .. "<Ignore>", true, false, true)
        vim.api.nvim_feedkeys(key, "t", false)
    end

    return {
        type = "button",
        val = txt,
        on_press = on_press,
        opts = opts,
    }
end

--- @param file string
--- @return string
local function shorten_path(file)
    return file:sub(file:match("(.*/)(.*/)"):len(), file:len())
end

--- @param file string
--- @return string
local function fnname(file)
    return shorten_path(vim.fs.dirname(file)) .. "/" .. vim.fs.basename(file)
end

--- @param fn string File name
--- @param short_fn string? A shortened file name
local function file_button(fn, sc, short_fn, autocd)
    short_fn = short_fn or shorten_path(fn)

    local ico_txt
    local fb_hl = {}

    if file_icons.enabled then
        local ico, hl = utils.get_icon(file_icons, fn)
        local hl_option_type = type(file_icons.highlight)
        if hl_option_type == "boolean" then
            if hl and file_icons.highlight then
                table.insert(fb_hl, { hl, 0, #ico })
            end
        end
        if hl_option_type == "string" then
            table.insert(fb_hl, { file_icons.highlight, 0, #ico })
        end
        ico_txt = ico .. "  "
    else
        ico_txt = ""
    end

    local cd_cmd = (autocd and " | cd %:p:h" or "")
    local file_button_el = button(sc, ico_txt .. short_fn, "<cmd>e " .. vim.fn.fnameescape(fn) .. cd_cmd .. " <CR>")

    local fn_start = short_fn:match(".*[/\\]")
    if fn_start ~= nil then
        table.insert(fb_hl, { "Comment", #ico_txt, #fn_start + #ico_txt })
    end
    file_button_el.opts.hl = fb_hl
    return file_button_el
end

--- @param items_number number?
--- @param opts table?
local function git_mru(start, items_number, cwd, opts)
    opts = opts or mru_opts
    items_number = items_number or 10
    local found = utils.get_git_files(cwd, items_number, opts.ignore)

    local tbl = {}

    for i, fn in ipairs(found) do
        local short_fn = fnname(fn)

        local file_button_el = file_button(fn, tostring(i + start - 1) .. " <alphaleader>", short_fn, opts.autocd)
        tbl[i] = file_button_el
    end

    return {
        type = "group",
        val = tbl,
        opts = {},
    }
end

--- A list of very important sayings.
--- @type List<string | table<integer, string>>
local quotes = {
    "\"There is Still Time\"",
    "\"A Monad is a Monoid in the Category of Endofunctors\"",
    "Functor? I hardly know er!",
    "∞-groupoids, yum",
    "Uninstall French: sudo rm -fr /"
}

local quote = {
    type = "text",

    opts = {
        hl = "Comment",
        position = "center",
    },

    val = function()
        return quotes[math.random(1, #quotes)]
    end,
}

local startpage = {
    layout = {
        { type = "padding", val = 2 },

        header,

        { type = "padding", val = 2 },

        quote,

        { type = "padding", val = 3 },

        menu_button("  Find File", "Telescope find_files", "f"),
        menu_button("  New File", "ene", "n"),
        menu_button("  Quit", "qa", "q"),

        { type = "padding", val = 1 },

        {
            type = "group",
            val = function()
                return { git_mru(0, 10) }
            end,
        },
    },
    opts = {
        margin = 5,
    },
}

alpha.setup(startpage)
