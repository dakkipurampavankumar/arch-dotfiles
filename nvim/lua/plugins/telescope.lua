return {
  "nvim-telescope/telescope.nvim",
  cmd = { "Telescope" },
  keys = {
    { "<leader>ff", function() require("telescope.builtin").find_files() end, desc = "Find Files" },
    { "<leader>fg", function() require("telescope.builtin").live_grep() end, desc = "Find by Grep" },
    { "<leader>fb", function() require("telescope.builtin").buffers() end, desc = "Find Buffers" },
    { "<leader>fr", function() require("telescope.builtin").oldfiles() end, desc = "Find Recent files" },
    { "<leader>fc", function() require("telescope.builtin").current_buffer_fuzzy_find() end, desc = "Find in Current buffer" },
    { "<leader>fh", function() require("telescope.builtin").help_tags() end, desc = "Find Help tags" },
  },
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
  end
}
