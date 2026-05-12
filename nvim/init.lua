require('core.options')

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then error('Error cloning lazy.nvim:\n' .. out) end
end

local rtp = vim.opt.rtp
rtp:prepend(lazypath)

require('lazy').setup()

-- Force transparency across all Neovim UI elements
local transparent_hls = {
  "Normal",
  "NormalNC",
  "LineNr",
  "Folded",
  "NonText",
  "SpecialKey",
  "VertSplit",
  "SignColumn",
  "EndOfBuffer",
  "TelescopeNormal",
  "TelescopeBorder",
}

for _, hl in ipairs(transparent_hls) do
  vim.api.nvim_set_hl(0, hl, { bg = "none", ctermbg = "none" })
end
