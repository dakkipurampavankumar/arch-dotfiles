return {
  "stevearc/dressing.nvim",
  event = "VeryLazy",
  opts = {
    input = {
      -- Used for things like renaming (<leader>rn)
      enabled = true,
      default_prompt = "Input:",
      insert_only = true,
      win_options = {
        winblend = 0, -- Set to 0 so it matches your solid background
      },
    },
    select = {
      -- Used for things like Code Actions (<leader>ca)
      enabled = true,
      -- This tells it to use Telescope for selection menus if possible!
      backend = { "telescope", "builtin", "nui" },
      trim_prompt = true,
    },
  }
}
