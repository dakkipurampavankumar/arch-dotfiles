return {
  "kylechui/nvim-surround",
  version = "*", -- Use for stability
  event = "VeryLazy",
  config = function()
    require("nvim-surround").setup({
      -- We leave this empty to use all the fantastic default keybindings:
      -- cs"'  -> change surround " to '
      -- ds"   -> delete surround "
      -- ysiw" -> yank surround inner word (wrap word in ")
    })
  end
}
