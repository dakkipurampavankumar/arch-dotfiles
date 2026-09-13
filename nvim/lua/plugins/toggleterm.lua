return {
  "akinsho/toggleterm.nvim",
  version = "*",
  config = function()
    require("toggleterm").setup({
      size = 15,
      open_mapping = [[<C-\>]], -- The exact same shortcut VSCode uses
      hide_numbers = true,
      shade_filetypes = {},
      shade_terminals = true,
      shading_factor = 2,
      start_in_insert = true,
      insert_mappings = true,
      terminal_mappings = true,
      persist_size = true,
      direction = "horizontal", -- Opens at the bottom like VSCode
      close_on_exit = true,
      shell = vim.o.shell,
    })

    -- Quality of Life: Easy ways to exit the terminal and navigate windows
    function _G.set_terminal_keymaps()
      local opts = {buffer = 0}
      -- Press 'kj' or 'Esc' to exit terminal typing mode (just like your other keymaps)
      vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
      vim.keymap.set('t', 'kj', [[<C-\><C-n>]], opts)
      
      -- Easy window navigation straight from the terminal
      vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
      vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
      vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
      vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
    end

    vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
  end
}
