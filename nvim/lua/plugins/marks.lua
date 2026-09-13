return {
  "chentoast/marks.nvim",
  event = "VeryLazy",
  opts = {
    -- whether to map keybinds or not. default true
    default_mappings = true,
    -- which builtin marks to show. default {}
    builtin_marks = {},
    -- whether movements cycle back to the beginning/end of buffer. default true
    cyclic = true,
    -- how often (in ms) to redraw signs/recompute mark positions.
    refresh_interval = 250,
    -- sign priorities for each type of mark
    sign_priority = { lower=10, upper=15, builtin=8, bookmark=20 },
  }
}
