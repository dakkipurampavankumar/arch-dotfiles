return {
  'windwp/nvim-autopairs',
  event = "InsertEnter",
  opts = {
    check_ts = true, -- Use Treesitter to skip pairing inside comments/strings
    fast_wrap = {},   -- Enable <Alt-e> to wrap existing words with brackets
  },
}
