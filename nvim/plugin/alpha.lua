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

--- @param label string
local function top_button(label, cmd, shortcut)
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
        },
    }
end

local find_button = top_button("  Find File", "Telescope find_files", "f")
-- {
--     type = "button",
--     val = "  Find File",
--     on_press = function() vim.cmd("Telescope find_files") end,
--     opts = {
--         shortcut = "f",
--         keymap = {
--             "n",
--             "f",
--             "<cmd>Telescope find_files<cr>",
--             {
--                 noremap = true,
--                 silent = true,
--                 nowait = true,
--             }
--         },
--
--         position = "center",
--         cursor = 3,
--         width = 60,
--
--         align_shortcut = "right",
--         hl_shortcut = "Keyword",
--     },
-- }

local new_file_button = top_button("  New File", "ene", "n")
-- {
--     type = "button",
--     val = "  New File",
--     on_press = function() vim.cmd [[ene]] end,
--     opts = {
--         shortcut = "n",
--         keymap = {
--             "n",
--             "n",
--             ":ene <BAR> startinsert <CR>",
--             {
--                 noremap = true,
--                 silent = true,
--                 nowait = true,
--             }
--         },
--
--         position = "center",
--         cursor = 3,
--         width = 60,
--
--         align_shortcut = "right",
--         hl_shortcut = "Keyword",
--     },
-- }

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

local alphaleader = "m"

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
    "Funtor? I hardly know er!",
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
        find_button,
        { type = "padding", val = 1 },
        new_file_button,
        { type = "padding", val = 1 },
        quit_button,
        { type = "padding", val = 1 },
        {
            type = "group",
            val = function()
                return { git_mru(0, 30) }
            end,
        },
    },
    opts = {
        margin = 5,
    },
}

alpha.setup(startpage)
