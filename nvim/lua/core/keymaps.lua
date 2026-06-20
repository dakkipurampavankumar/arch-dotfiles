-- Set leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Disable the spacebar key's default behavior in Normal and Visual modes
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- For conciseness
local opts = { noremap = true, silent = true }

--return to noraml
vim.keymap.set('i', 'kj', '<Esc>', opts)

-- save file
vim.keymap.set('n', '<C-s>', '<cmd> w <CR>', opts)

-- save file without auto-formatting
vim.keymap.set('n', '<leader>sn', '<cmd>noautocmd w <CR>', opts)

-- quit file
vim.keymap.set('n', '<C-q>', '<cmd> q <CR>', opts)

-- delete single character without copying into register
vim.keymap.set('n', 'x', '"_x', opts)

-- Vertical scroll and center
vim.keymap.set('n', '<C-d>', '<C-d>zz', opts)
vim.keymap.set('n', '<C-u>', '<C-u>zz', opts)

-- Find and center
vim.keymap.set('n', 'n', 'nzzzv', opts)
vim.keymap.set('n', 'N', 'Nzzzv', opts)

-- Resize with arrows
vim.keymap.set('n', '<Up>', ':resize -2<CR>', opts)
vim.keymap.set('n', '<Down>', ':resize +2<CR>', opts)
vim.keymap.set('n', '<Left>', ':vertical resize -2<CR>', opts)
vim.keymap.set('n', '<Right>', ':vertical resize +2<CR>', opts)

-- Buffers
vim.keymap.set('n', '<Tab>', ':bnext<CR>', opts)
vim.keymap.set('n', '<S-Tab>', ':bprevious<CR>', opts)
vim.keymap.set('n', '<leader>x', ':bdelete!<CR>', opts) -- close buffer
vim.keymap.set('n', '<leader>b', '<cmd> enew <CR>', opts) -- new buffer

-- Window management
vim.keymap.set('n', '<leader>v', '<C-w>v', opts) -- split window vertically
vim.keymap.set('n', '<leader>h', '<C-w>s', opts) -- split window horizontally
vim.keymap.set('n', '<leader>se', '<C-w>=', opts) -- make split windows equal width & height
vim.keymap.set('n', '<leader>xs', ':close<CR>', opts) -- close current split window

-- Navigate between splits
vim.keymap.set('n', '<C-k>', ':wincmd k<CR>', opts)
vim.keymap.set('n', '<C-j>', ':wincmd j<CR>', opts)
vim.keymap.set('n', '<C-h>', ':wincmd h<CR>', opts)
vim.keymap.set('n', '<C-l>', ':wincmd l<CR>', opts)

-- Tabs
vim.keymap.set('n', '<leader>to', ':tabnew<CR>', opts) -- open new tab
vim.keymap.set('n', '<leader>tx', ':tabclose<CR>', opts) -- close current tab
vim.keymap.set('n', '<leader>tn', ':tabn<CR>', opts) --  go to next tab
vim.keymap.set('n', '<leader>tp', ':tabp<CR>', opts) --  go to previous tab

-- Toggle line wrapping
vim.keymap.set('n', '<leader>lw', '<cmd>set wrap!<CR>', opts)

-- Stay in indent mode
vim.keymap.set('v', '<', '<gv', opts)
vim.keymap.set('v', '>', '>gv', opts)

-- Keep last yanked when pasting
vim.keymap.set('v', 'p', '"_dP', opts)

-- Diagnostic keymaps
vim.keymap.set('n', '[d', function()
  vim.diagnostic.jump { count = -1, float = true }
end, { desc = 'Go to previous diagnostic message' })

vim.keymap.set('n', ']d', function()
  vim.diagnostic.jump { count = 1, float = true }
end, { desc = 'Go to next diagnostic message' })

vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- F5 to run any program
vim.keymap.set('n', '<F5>', function()
  -- 1. Save the file before running
  vim.cmd('write')

  -- 2. Get absolute paths to avoid directory/path issues
  local filetype = vim.bo.filetype
  local file = vim.fn.expand('%:p')       -- e.g., /home/pavan/project/main.c
  local out_file = vim.fn.expand('%:p:r') -- e.g., /home/pavan/project/main
  local file_dir = vim.fn.expand('%:p:h') -- e.g., /home/pavan/project

  -- 3. Base commands (cd into the file's directory first for safety)
  local cd_cmd = 'cd ' .. file_dir .. ' && '
  local commands = {
    python = cd_cmd .. 'python3 ' .. file,
    javascript = cd_cmd .. 'node ' .. file,
    sh = cd_cmd .. 'bash ' .. file,
    go = cd_cmd .. 'go run ' .. file,
    c = cd_cmd .. 'gcc ' .. file .. ' -o ' .. out_file .. ' && ' .. out_file,
    cpp = cd_cmd .. 'g++ ' .. file .. ' -o ' .. out_file .. ' && ' .. out_file,
  }

  -- 4. Smart handling for Rust
  if filetype == 'rust' then
    -- Searches upwards from the current file's directory for Cargo.toml
    local is_cargo = vim.fn.findfile('Cargo.toml', file_dir .. ';')
    
    if is_cargo ~= '' then
      -- If Cargo.toml is found, tell cargo exactly where it is located
      commands.rust = 'cargo run --manifest-path ' .. is_cargo
    else
      -- Fallback for standalone .rs files
      commands.rust = cd_cmd .. 'rustc ' .. file .. ' -o ' .. out_file .. ' && ' .. out_file
    end
  end

  -- 5. Execute the command
  local cmd = commands[filetype]

  if cmd then
    vim.cmd('botright 12split | term ' .. cmd)
    vim.cmd('startinsert')
  else
    print('No F5 run command configured for filetype: ' .. filetype)
  end

end, { desc = 'Run code based on filetype' })vim.keymap.set('i', '<C-h>', '<Left>', opts)
vim.keymap.set('i', '<C-j>', '<Down>', opts)
vim.keymap.set('i', '<C-k>', '<Up>', opts)
vim.keymap.set('i', '<C-l>', '<Right>', opts)
