return { -- Highlight, edit, and navigate code
  'nvim-treesitter/nvim-treesitter',
  branch = 'main',
  build = ':TSUpdate',
  main = 'nvim-treesitter', -- Explicitly tell Lazy to use the root module
  opts = {
    ensure_installed = {
      'c',
      'rust',
      'cpp',
      'query',
      'lua',
      'python',
      'javascript',
      'typescript',
      'vimdoc',
      'vim',
      'regex',
      'terraform',
      'sql',
      'dockerfile',
      'toml',
      'json',
      'java',
      'groovy',
      'go',
      'gitignore',
      'graphql',
      'yaml',
      'make',
      'cmake',
      'markdown',
      'markdown_inline',
      'bash',
      'tsx',
      'css',
      'html',
    },
    -- Autoinstall languages that are not installed
    auto_install = true,
  },
  -- Note: highlight, indent, and incremental_selection modules have been 
  -- removed from the main branch. Neovim handles syntax highlighting 
  -- and indenting via Tree-sitter natively now.
}
