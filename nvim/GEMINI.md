# Neovim Configuration

This is a modern, Lua-based Neovim configuration designed for performance, aesthetics, and a smooth development workflow. It uses **lazy.nvim** as the plugin manager and is organized into core settings and modular plugin configurations.

## Project Overview

- **Main Technologies:** Lua, Neovim 0.10+, lazy.nvim.
- **Architecture:**
    - `init.lua`: Main entry point. Bootstraps the plugin manager and applies global UI tweaks (e.g., transparency).
    - `lua/core/`: Contains fundamental editor settings.
        - `options.lua`: Neovim options (line numbers, indentation, clipboard, etc.).
        - `keymaps.lua`: Global keybindings for navigation, window management, and buffer control.
    - `lua/plugins/`: Modular plugin configurations. Each file returns a `LazySpec`.

## Key Features & Plugins

- **Plugin Manager:** [lazy.nvim](https://github.com/folke/lazy.nvim) for fast and lazy-loading of plugins.
- **Fuzzy Finding:** [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) for searching files, buffers, and text.
- **File Management:** [yazi.nvim](https://github.com/mikavilpas/yazi.nvim) integration for an efficient terminal-based file manager experience.
- **LeetCode:** [leetcode.nvim](https://github.com/kawre/leetcode.nvim) for solving coding challenges directly within Neovim.
- **UI Enhancements:**
    - [bufferline.lua](lua/plugins/bufferline.lua): Modern tab-like buffer line.
    - [lualine.lua](lua/plugins/lualine.lua): Highly customizable status line.
    - **Transparency:** Custom logic in `init.lua` ensures a transparent UI across various highlight groups.

## Essential Keymaps

The `<leader>` key is mapped to `<Space>`.

### General
| Keymap | Action |
| :--- | :--- |
| `kj` | Return to Normal mode (Insert mode) |
| `<C-s>` | Save file |
| `<leader>sn` | Save without auto-formatting |
| `<C-q>` | Quit |
| `<C-d>` / `<C-u>` | Scroll down/up and center |

### Telescope (`<leader>f`)
| Keymap | Action |
| :--- | :--- |
| `<leader>ff` | Find Files |
| `<leader>fg` | Live Grep |
| `<leader>fb` | Find Buffers |
| `<leader>fr` | Recent Files |
| `<leader>fc` | Find in Current Buffer |

### File Manager (Yazi)
| Keymap | Action |
| :--- | :--- |
| `<leader>e` | Open Yazi at current file |
| `<leader>ew` | Open Yazi in working directory |

## Development Conventions

- **Indentation:** 4 spaces (`shiftwidth=4`, `tabstop=4`, `expandtab=true`).
- **Style:** Modular Lua files. Plugins should be added as separate files in `lua/plugins/`.
- **Transparency:** Maintain the transparency logic in `init.lua` when adding new UI plugins.

## Setup & Maintenance

- **Installation:** Clone into `~/.config/nvim`. Neovim will automatically bootstrap `lazy.nvim` on first launch.
- **Update Plugins:** Run `:Lazy sync` within Neovim.
- **LeetCode Setup:** Requires `:TSUpdate html` for proper rendering.
