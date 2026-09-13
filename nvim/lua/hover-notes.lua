-- hover-notes.lua
-- Notion-like comments for markdown files in Neovim.
--
-- Annotate any word → it gets an underline + 💬 icon.
-- Put your cursor on it → a popup shows the comment automatically.
-- Comments are stored in a sidecar .comments.json file (your .md stays clean).

local M = {}

local ns = vim.api.nvim_create_namespace("hover_notes")
local cache = {} -- { [filepath] = { {line=N, word="...", text="..."}, ... } }

-- Float state
local float_win = nil
local float_buf = nil
local float_key = nil -- "line:word" to track what's currently shown
local float_images = {} -- image paths found in current comment

-- ═══════════════════════════════════════════════════════════
-- STORAGE: comments are saved as a .comments.json next to your .md file
-- ═══════════════════════════════════════════════════════════

local function sidecar(filepath)
  return filepath .. ".comments.json"
end

local function load(filepath)
  if cache[filepath] then return end
  local f = io.open(sidecar(filepath), "r")
  if not f then
    cache[filepath] = {}
    return
  end
  local raw = f:read("*a")
  f:close()
  local ok, data = pcall(vim.json.decode, raw)
  cache[filepath] = (ok and type(data) == "table") and data or {}
end

local function save(filepath)
  local data = cache[filepath]
  if not data or #data == 0 then
    os.remove(sidecar(filepath))
    return
  end
  local f = io.open(sidecar(filepath), "w")
  if f then
    f:write(vim.json.encode(data))
    f:close()
  end
end

-- ═══════════════════════════════════════════════════════════
-- RENDERING: underline annotated words + add 💬 icon at end of line
-- ═══════════════════════════════════════════════════════════

local function render(buf, filepath)
  vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
  local data = cache[filepath]
  if not data then return end

  local seen_lines = {} -- only one 💬 per line

  for _, c in ipairs(data) do
    local lnum = c.line - 1 -- extmark API is 0-indexed
    local lines = vim.api.nvim_buf_get_lines(buf, lnum, lnum + 1, false)
    if lines[1] then
      -- Underline the word
      local s = lines[1]:find(c.word, 1, true)
      if s then
        s = s - 1 -- 0-indexed
        pcall(vim.api.nvim_buf_set_extmark, buf, ns, lnum, s, {
          end_col = s + #c.word,
          hl_group = "HoverNoteWord",
        })
      end
      -- 💬 at end of line (once per line)
      if not seen_lines[lnum] then
        pcall(vim.api.nvim_buf_set_extmark, buf, ns, lnum, 0, {
          virt_text = { { " 💬", "DiagnosticHint" } },
          virt_text_pos = "eol",
        })
        seen_lines[lnum] = true
      end
    end
  end
end

-- ═══════════════════════════════════════════════════════════
-- POPUP: floating window that shows the comment
-- ═══════════════════════════════════════════════════════════

local function close_float()
  if float_win and vim.api.nvim_win_is_valid(float_win) then
    vim.api.nvim_win_close(float_win, true)
  end
  float_win = nil
  float_buf = nil
  float_key = nil
  float_images = {}
end

local function make_key(c)
  return c.line .. ":" .. c.word
end

local function detect_images(text)
  local imgs = {}
  local seen = {}
  -- Match markdown images: ![alt](path)
  for path in text:gmatch("!%[.-%]%((.-)%)") do
    if not seen[path] then
      table.insert(imgs, path)
      seen[path] = true
    end
  end
  return imgs
end

local function show_float(comment)
  close_float()

  local lines = vim.split(comment.text, "\n")
  local images = detect_images(comment.text)

  -- Hint line if there are images
  if #images > 0 then
    table.insert(lines, "")
    table.insert(lines, "─────────────────────────────")
    table.insert(lines, "  <leader>no → open image(s)")
  end

  -- Calculate window size
  local width = 10
  for _, l in ipairs(lines) do
    width = math.max(width, vim.fn.strdisplaywidth(l))
  end
  width = math.min(width + 4, 78)
  local height = math.min(#lines, 18)

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].filetype = "markdown"
  vim.bo[buf].modifiable = false
  vim.bo[buf].bufhidden = "wipe"

  local win = vim.api.nvim_open_win(buf, false, {
    relative = "cursor",
    row = 1,
    col = 0,
    width = width,
    height = height,
    style = "minimal",
    border = "rounded",
    title = " 💬 " .. comment.word .. " ",
    title_pos = "center",
  })

  float_win = win
  float_buf = buf
  float_key = make_key(comment)
  float_images = images
end

-- ═══════════════════════════════════════════════════════════
-- CURSOR DETECTION: find comment at current cursor position
-- ═══════════════════════════════════════════════════════════

local function at_cursor()
  local filepath = vim.fn.expand("%:p")
  load(filepath)
  if not cache[filepath] or #cache[filepath] == 0 then
    return nil, nil, filepath
  end

  local cur = vim.api.nvim_win_get_cursor(0)
  local cur_line = cur[1] -- 1-indexed
  local cur_col = cur[2] -- 0-indexed

  local buf = vim.api.nvim_get_current_buf()
  local line_text = vim.api.nvim_buf_get_lines(buf, cur_line - 1, cur_line, false)[1]
  if not line_text then return nil, nil, filepath end

  for i, c in ipairs(cache[filepath]) do
    if c.line == cur_line then
      local s = line_text:find(c.word, 1, true)
      if s then
        s = s - 1 -- 0-indexed
        if cur_col >= s and cur_col < s + #c.word then
          return c, i, filepath
        end
      end
    end
  end

  return nil, nil, filepath
end

-- ═══════════════════════════════════════════════════════════
-- EDITOR: floating scratch buffer to write/edit comments
-- ═══════════════════════════════════════════════════════════

local function open_editor(filepath, orig_buf, line, word)
  -- Check if a comment already exists for this word on this line
  local existing_idx, existing_text
  for i, c in ipairs(cache[filepath]) do
    if c.line == line and c.word == word then
      existing_idx = i
      existing_text = c.text
      break
    end
  end

  local ed_buf = vim.api.nvim_create_buf(false, true)
  local ed_w, ed_h = 60, 10

  -- Pre-fill if editing an existing comment
  if existing_text then
    vim.api.nvim_buf_set_lines(ed_buf, 0, -1, false, vim.split(existing_text, "\n"))
  end

  vim.bo[ed_buf].filetype = "markdown"
  vim.bo[ed_buf].bufhidden = "wipe"

  local ed_win = vim.api.nvim_open_win(ed_buf, true, {
    relative = "editor",
    row = math.floor(vim.o.lines / 2) - math.floor(ed_h / 2),
    col = math.floor(vim.o.columns / 2) - math.floor(ed_w / 2),
    width = ed_w,
    height = ed_h,
    style = "minimal",
    border = "rounded",
    title = existing_idx
        and (" ✏️  Edit: " .. word .. " ")
        or (" 💬 Comment on: " .. word .. " "),
    title_pos = "center",
    footer = " Ctrl+s save │ q cancel │ images: ![desc](path) ",
    footer_pos = "center",
  })

  vim.cmd("startinsert")

  -- SAVE: Ctrl+s in both insert and normal mode
  vim.keymap.set({ "n", "i" }, "<C-s>", function()
    local content = vim.api.nvim_buf_get_lines(ed_buf, 0, -1, false)
    local text = table.concat(content, "\n"):gsub("\n+$", "")

    if text ~= "" then
      if existing_idx then
        cache[filepath][existing_idx].text = text
      else
        table.insert(cache[filepath], { line = line, word = word, text = text })
      end
      save(filepath)
      vim.schedule(function()
        if vim.api.nvim_buf_is_valid(orig_buf) then
          render(orig_buf, filepath)
        end
      end)
      vim.notify("💬 Comment saved on '" .. word .. "'", vim.log.levels.INFO)
    else
      vim.notify("Empty comment — not saved", vim.log.levels.WARN)
    end

    if vim.api.nvim_win_is_valid(ed_win) then
      vim.api.nvim_win_close(ed_win, true)
    end
  end, { buffer = ed_buf, desc = "Save comment" })

  -- CANCEL: q in normal mode (you can still type 'q' in insert mode)
  vim.keymap.set("n", "q", function()
    if vim.api.nvim_win_is_valid(ed_win) then
      vim.api.nvim_win_close(ed_win, true)
    end
  end, { buffer = ed_buf, desc = "Cancel comment" })
end

-- ═══════════════════════════════════════════════════════════
-- PUBLIC: the functions you call via keymaps
-- ═══════════════════════════════════════════════════════════

--- Add or edit a comment on the word under cursor (normal mode)
--- or on the visually selected text (visual mode).
function M.add_comment()
  local filepath = vim.fn.expand("%:p")
  load(filepath)

  local mode = vim.api.nvim_get_mode().mode
  local word, line
  local orig_buf = vim.api.nvim_get_current_buf()

  if mode == "v" or mode == "V" or mode == "\22" then
    -- VISUAL MODE: get the selected text
    local vs = vim.fn.getpos("v") -- start of visual area
    local ve = vim.fn.getpos(".") -- cursor (end of visual area)

    -- Normalize so vs is before ve
    if vs[2] > ve[2] or (vs[2] == ve[2] and vs[3] > ve[3]) then
      vs, ve = ve, vs
    end

    -- Only support single-line selections
    if vs[2] ~= ve[2] then
      vim.api.nvim_feedkeys(
        vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "nx", false)
      vim.notify("Select text on a single line only", vim.log.levels.WARN)
      return
    end

    line = vs[2]
    local line_text = vim.api.nvim_buf_get_lines(0, line - 1, line, false)[1]
    word = line_text:sub(vs[3], ve[3]) -- sub is 1-indexed, getpos is 1-indexed

    -- Exit visual mode
    vim.api.nvim_feedkeys(
      vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "nx", false)
  else
    -- NORMAL MODE: use the word under cursor
    word = vim.fn.expand("<cword>")
    line = vim.fn.line(".")
  end

  if not word or word == "" then
    vim.notify("No word selected", vim.log.levels.WARN)
    return
  end

  -- Schedule to let the mode switch settle
  vim.schedule(function()
    open_editor(filepath, orig_buf, line, word)
  end)
end

--- Delete the comment on the word under cursor.
function M.delete_comment()
  local comment, idx, filepath = at_cursor()
  if not comment then
    vim.notify("No comment on this word", vim.log.levels.INFO)
    return
  end
  table.remove(cache[filepath], idx)
  save(filepath)
  render(vim.api.nvim_get_current_buf(), filepath)
  vim.notify("💬 Deleted comment on '" .. comment.word .. "'", vim.log.levels.INFO)
end

--- List all comments in the current file in a quickfix window.
function M.list_comments()
  local filepath = vim.fn.expand("%:p")
  load(filepath)
  if not cache[filepath] or #cache[filepath] == 0 then
    vim.notify("No comments in this file", vim.log.levels.INFO)
    return
  end

  local items = {}
  for _, c in ipairs(cache[filepath]) do
    table.insert(items, {
      filename = filepath,
      lnum = c.line,
      text = "💬 [" .. c.word .. "] " .. c.text:gsub("\n", " ↵ "),
    })
  end
  table.sort(items, function(a, b) return a.lnum < b.lnum end)

  vim.fn.setqflist(items, "r")
  vim.fn.setqflist({}, "a", { title = "💬 Comments in " .. vim.fn.expand("%:t") })
  vim.cmd("copen")
end

--- Open image(s) referenced in the currently visible comment popup.
function M.open_images()
  if #float_images == 0 then
    vim.notify("No images in this comment", vim.log.levels.INFO)
    return
  end

  local file_dir = vim.fn.expand("%:p:h")
  for _, img in ipairs(float_images) do
    local path = img
    -- Resolve relative paths against the markdown file's directory
    if not path:match("^[/~]") then
      path = file_dir .. "/" .. path
    end
    path = vim.fn.expand(path)

    if vim.fn.filereadable(path) == 1 then
      vim.fn.jobstart({ "xdg-open", path }, { detach = true })
    else
      vim.notify("Image not found: " .. path, vim.log.levels.WARN)
    end
  end
end

-- ═══════════════════════════════════════════════════════════
-- AUTOCMD HANDLERS: auto-show popup on hover, auto-close on move
-- ═══════════════════════════════════════════════════════════

function M._on_cursor_hold()
  if vim.bo.filetype ~= "markdown" then return end

  -- Don't trigger if we're inside a floating window (like the editor)
  local win_config = vim.api.nvim_win_get_config(0)
  if win_config.relative and win_config.relative ~= "" then return end

  local comment = at_cursor()
  if comment then
    -- Don't reopen if already showing this exact comment
    if float_key == make_key(comment) then return end
    show_float(comment)
  else
    close_float()
  end
end

function M._on_cursor_moved()
  if not float_win then return end
  local comment = at_cursor()
  if not comment or make_key(comment) ~= float_key then
    close_float()
  end
end

-- ═══════════════════════════════════════════════════════════
-- SETUP: call this once to activate everything
-- ═══════════════════════════════════════════════════════════

function M.setup()
  -- Dotted underline for annotated words (falls back to regular underline
  -- in terminals that don't support underdotted)
  vim.api.nvim_set_hl(0, "HoverNoteWord", {
    underdotted = true,
    sp = "#7aa2f7",
  })

  -- Load comments and render marks when opening a markdown file
  vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost" }, {
    pattern = "*.md",
    callback = function(ev)
      local filepath = vim.fn.expand("%:p")
      cache[filepath] = nil -- force reload from disk
      load(filepath)
      render(ev.buf, filepath)
    end,
  })

  -- Show popup automatically when cursor sits on an annotated word
  -- (triggers after 'updatetime' ms — you have it set to 500ms)
  vim.api.nvim_create_autocmd("CursorHold", {
    pattern = "*.md",
    callback = M._on_cursor_hold,
  })

  -- Close popup when cursor moves away from the annotated word
  vim.api.nvim_create_autocmd("CursorMoved", {
    pattern = "*.md",
    callback = M._on_cursor_moved,
  })

  -- Keymaps — only active in markdown files
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "markdown",
    callback = function()
      local o = { buffer = true, silent = true }

      -- Add/edit comment (works in normal + visual mode)
      vim.keymap.set({ "n", "v" }, "<leader>nc", M.add_comment,
        vim.tbl_extend("force", o, { desc = "💬 Add/edit comment" }))

      -- Delete comment on word under cursor
      vim.keymap.set("n", "<leader>nd", M.delete_comment,
        vim.tbl_extend("force", o, { desc = "💬 Delete comment" }))

      -- List all comments in quickfix
      vim.keymap.set("n", "<leader>nl", M.list_comments,
        vim.tbl_extend("force", o, { desc = "💬 List all comments" }))

      -- Open image(s) from the currently visible comment popup
      vim.keymap.set("n", "<leader>no", M.open_images,
        vim.tbl_extend("force", o, { desc = "💬 Open image from comment" }))
    end,
  })
end

return M
