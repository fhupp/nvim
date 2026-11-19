local function load()
  require("telescope").setup({
    defaults = {
      layout_strategy = "vertical",

      layout_config = {
        vertical = { width = 0.5, height = 0.8 },
      },

      borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },

    },
  })
end

require("lze").load({
  "telescope.nvim",
  event = "VimEnter",
  after = function()
    vim.schedule(load)
  end
})
