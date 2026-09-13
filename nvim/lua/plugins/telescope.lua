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
    { 
      "nvim-telescope/telescope-fzf-native.nvim", 
      build = "make" 
    },
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")

    telescope.setup({
      defaults = {
        prompt_prefix = "   ",
        selection_caret = " ❯ ",
        path_display = { "truncate" },

        -- These are a safety net. The real speed comes from fd flags below.
        file_ignore_patterns = {
          "%.git/",
          "node_modules/",
          "%.o$",
          "%.out$",
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
          -- Instead of letting Telescope use its default finder and then filtering
          -- 125,000 results in Lua (slow!), we tell it to use `fd` directly.
          -- fd skips excluded folders at the filesystem level so they are never even read.
          find_command = {
            "fd",
            "--type", "f",
            "--hidden",        -- show dotfiles like .bashrc
            "--follow",        -- follow symlinks (fixes ~/vaults -> /mnt/HDD/vaults)
            "--exclude", ".git",
            "--exclude", "node_modules",
            "--exclude", "build",
            "--exclude", "target",
            -- Heavy hidden folders that were causing the 1-second freeze:
            "--exclude", ".cargo",
            "--exclude", ".rustup",
            "--exclude", ".npm",
            "--exclude", ".cache",
            "--exclude", ".local",
            "--exclude", ".android",
            "--exclude", ".gnupg",
          },
        },
        live_grep = {
          additional_args = function()
            return {
              "--follow",       -- follow symlinks
              "--hidden",       -- search inside dotfiles
              "--glob", "!.git/",
              "--glob", "!.cargo/",
              "--glob", "!.rustup/",
              "--glob", "!.npm/",
              "--glob", "!.cache/",
              "--glob", "!.local/",
              "--glob", "!node_modules/",
            }
          end,
        },
        buffers = {
          initial_mode = "normal",
          mappings = {
            i = { ["<C-d>"] = actions.delete_buffer, },
            n = { ["dd"] = actions.delete_buffer, },
          },
        },
      },
      extensions = {
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = "smart_case",
        }
      }
    })

    telescope.load_extension("fzf")
  end
}
