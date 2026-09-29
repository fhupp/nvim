local alpha = require("alpha")
local utils = require("alpha.utils")

local file_icons = {
    enabled = true,
    highlight = true,
    -- available: devicons, mini, to use nvim-web-devicons or mini.icons
    -- if provider not loaded and enabled is true, it will try to use another provider
    provider = "devicons",
}

local header = {
    type = "text",

    opts = {
        hl = "Type",
        position = "center",
    },

    val = {
        -- "▗▖  ▗▖▄   ▄ ▄ ▄▄▄▄",
        -- "▐▛▚▖▐▌█   █ ▄ █ █ █",
        -- "▐▌ ▝▜▌ ▀▄▀  █ █   █",
        -- "▐▌  ▐▌      █",
        "   Neo         ",
        "    VIsual ex  ",
        "     iMproved  ",
    },
}

local find_button = {
    type = "button",
    val = "  Find File",
    on_press = function() vim.cmd("Telescope find_files") end,
    opts = {
        shortcut = "f",
        keymap = {
            "n",
            "f",
            "<cmd>Telescope find_files<cr>",
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
        hl_shortcut = "Keyword",
    },
}

local new_file_button = {
    type = "button",
    val = "  New File",
    on_press = function() vim.cmd [[ene]] end,
    opts = {
        shortcut = "n",
        keymap = {
            "n",
            "n",
            ":ene <BAR> startinsert <CR>",
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
        hl_shortcut = "Keyword",
    },
}

local quit_button = {
    type = "button",
    val = "  Quit",
    on_press = function() vim.cmd [[qa]] end,
    opts = {
        shortcut = "q",
        keymap = {
            "n",
            "q",
            ":qa<CR>",
            {
                noremap = true,
                silent = true,
                nowait = true,
            }
        },

        align_shortcut = "right",
        hl_shortcut = "Keyword",

        position = "center",
        cursor = 3,
        width = 60,
    },
}

local mru_opts = {
    ignore = function(path, ext)
        return (string.find(path, "COMMIT_EDITMSG")) or (vim.tbl_contains({ "gitcommit" }, ext))
    end,
    autocd = false
}

local leader = "SPC"

--- @param sc string
--- @param txt string
--- @param keybind string? optional
--- @param keybind_opts table? optional
local function button(sc, txt, keybind, keybind_opts)
    local sc_ = sc:gsub("%s", ""):gsub(leader, "<leader>")

    local opts = {
        position = "center",
        shortcut = sc,
        cursor = 3,
        width = 60,
        align_shortcut = "right",
        hl_shortcut = "Keyword",
        shrink_margin = false,
    }
    if keybind then
        keybind_opts = vim.F.if_nil(keybind_opts, { noremap = true, silent = true, nowait = true })
        opts.keymap = { "n", sc_, keybind, keybind_opts }
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

local function file_button(fn, sc, short_fn, autocd)
    short_fn = vim.F.if_nil(short_fn, fn)
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


--- @param file string
local function shorten_path(file)
    return file:sub(file:match("(.*/)(.*/)"):len(), file:len())
end

local function fnname(file)
    return ".." .. shorten_path(vim.fs.dirname(file)) .. "/" .. vim.fs.basename(file)
end

local function mru(start, cwd, items_number, opts)
    opts = opts or mru_opts
    items_number = vim.F.if_nil(items_number, 10)
    local found = utils.get_git_files(cwd, items_number, opts.ignore)

    local tbl = {}

    for i, fn in ipairs(found) do
        local short_fn = fnname(fn)

        local file_button_el = file_button(fn, tostring(i + start - 1), short_fn, opts.autocd)
        tbl[i] = file_button_el
    end

    return {
        type = "group",
        val = tbl,
        opts = {},
    }
end

local startpage = {
    layout = {
        { type = "padding", val = 2 },
        header,
        { type = "padding", val = 2 },
        find_button,
        { type = "padding", val = 1 },
        new_file_button,
        { type = "padding", val = 1 },
        quit_button,
        { type = "padding", val = 1 },
        {
            type = "group",
            val = function()
                return { mru(0) }
            end,
        },
    },
    opts = {
        margin = 5,
    },
}

alpha.setup(startpage)
