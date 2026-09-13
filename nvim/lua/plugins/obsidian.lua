return {
  "epwalsh/obsidian.nvim",
  version = "*",
  lazy = true,
  ft = "markdown", 
  
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MeanderingProgrammer/render-markdown.nvim",
  },
  
  keys = {
    -- Custom wrapper: runs ObsidianNew, then after a short delay forces 
    -- render-markdown to re-process the newly created buffer
    { "<leader>on", function()
        vim.cmd("ObsidianNew")
        -- Wait 500ms for Obsidian to finish creating file + writing frontmatter
        vim.defer_fn(function()
          local buf = vim.api.nvim_get_current_buf()
          -- Save the file first so render-markdown treats it as a real file
          pcall(vim.cmd, "silent! write")
          -- Force filetype re-detection (this triggers render-markdown to attach fresh)
          vim.bo[buf].filetype = ""
          vim.bo[buf].filetype = "markdown"
        end, 500)
      end, desc = "New Obsidian Note" },
    { "<leader>oq", "<cmd>ObsidianQuickSwitch<CR>", desc = "Quick Switch Note" },
    { "<leader>os", "<cmd>ObsidianSearch<CR>", desc = "Search in Vault" },
    { "<leader>ob", "<cmd>ObsidianBacklinks<CR>", desc = "Show Note Backlinks" },
  },

  opts = {
    workspaces = {
      {
        name = "main",
        path = "~/vaults", 
      },
    },
    ui = {
      enable = false, 
    },
    
    note_id_func = function(title)
      if title ~= nil then
        return title
      else
        return tostring(os.time())
      end
    end,

    note_frontmatter_func = function(note)
      local out = { id = note.id, aliases = note.aliases, tags = note.tags }
      if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
        for k, v in pairs(note.metadata) do
          out[k] = v
        end
      end
      return out
    end,
  },
  
  config = function(_, opts)
    require("obsidian").setup(opts)
  end,
}
