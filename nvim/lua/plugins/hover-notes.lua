-- Notion-like hover comments for markdown files.
-- See lua/hover-notes.lua for the full implementation.
return {
  name = "hover-notes",
  dir = vim.fn.stdpath("config"),
  ft = "markdown",
  config = function()
    require("hover-notes").setup()
  end,
}
