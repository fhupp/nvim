local function load()
  require("blink.cmp").setup(
    {
      completion = {
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 500,
        },

        list = { selection = { auto_insert = false, preselect = false } },

        menu = {
          enabled = true,
          border = 'none',
          draw = {
            columns = {
              { "label", "label_description", gap = 1 },
              { "kind", },
            },
          },
        }
      }
    }
  )
end

require('lze').load({
  "blink.cmp",
  event = "VimEnter",
  before = function()
    vim.schedule(load)
  end
})
