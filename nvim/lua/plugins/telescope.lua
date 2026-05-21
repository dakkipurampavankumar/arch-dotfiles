return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    -- The fzf-native extension and its build command
    { 
      "nvim-telescope/telescope-fzf-native.nvim", 
      build = "make" 
    },
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")
    local builtin = require("telescope.builtin")

    telescope.setup({
      defaults = {
        prompt_prefix = "  ",
        selection_caret = "  ",
        path_display = { "smart" },

        -- Keeps Telescope fast by ignoring build directories and object files
        file_ignore_patterns = {
          ".git/",
          "build/",
          "target/",
          "node_modules/",
          "%.o", 
          "%.out"
        },

        mappings = {
          i = {
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
            ["<Esc>"] = actions.close,
          },
          n = {
            ["q"] = actions.close,
          },
        },
      },
      pickers = {
        find_files = {
          hidden = true,
        },
        buffers = {
          initial_mode = "normal",
          mappings = {
            i = { ["<C-d>"] = actions.delete_buffer, },
            n = { ["dd"] = actions.delete_buffer, },
          },
        },
      },
      -- Configure the fzf extension
      extensions = {
        fzf = {
          fuzzy = true,                    -- false will only do exact matching
          override_generic_sorter = true,  -- override the generic sorter
          override_file_sorter = true,     -- override the file sorter
          case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
        }
      }
    })

    -- You must explicitly load the extension after setting it up
    telescope.load_extension("fzf")

    -- ==========================================
    -- Intuitive Keymaps (Starting with <leader>f)
    -- ==========================================
    vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Find Files' })
    vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Find by Grep' })
    vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Find Buffers' })
    vim.keymap.set('n', '<leader>fr', builtin.oldfiles, { desc = 'Find Recent files' })
    vim.keymap.set('n', '<leader>fc', builtin.current_buffer_fuzzy_find, { desc = 'Find in Current buffer' })
    vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Find Help tags' })
  end
}
