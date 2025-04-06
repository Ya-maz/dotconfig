-- Функция для проверки режима
-- В системе есть alias такого вида
-- alias nn='nvim --cmd "let g:weak_mode = 1"'
local function is_weak_mode()
    return vim.g.weak_mode == 1
end

local function get_keymap_opts(desc)
    return {
        noremap = true,
        silent = true,
        buffer = true,
        desc = desc
    }
end

local function apply_snippets(snippets)
    for _, snippet in ipairs(snippets) do
        vim.keymap.set(
            'i',
            snippet.key_map,
            snippet.command,
            get_keymap_opts(snippet.desc)
        )
    end
end

-- позволяет в :terminal открыть файл по курсором
local function open_file_under_cursor()
    local line = vim.api.nvim_get_current_line()
  -- Очищаем ANSI-коды
  line = line:gsub("\x1b%[%d*[%a]*", "")
    print("line" .. line)
  local file = line:match("/home/[%w/%.%-_]+%.[tj][sx]?")
  -- Пробуем относительный путь, если /home/ не найден
  if not file then
    file = line:match("[/%w%.%-_]+%.[tj][sx]?")
    if file and not vim.fn.filereadable(file) then
      file = vim.fn.getcwd() .. "/" .. file
    end
  end

  if file and vim.fn.filereadable(file) == 1 then
    -- Открываем файл
    vim.cmd("above split " .. vim.fn.fnameescape(file))
    -- Пытаемся извлечь номер строки из следующей строки
    local next_line = vim.api.nvim_buf_get_lines(0, vim.fn.line(".") - 1 + 1, vim.fn.line(".") + 1, false)[1] or ""
    print("Next line: " .. next_line) -- Отладка
    local lnum = next_line:match("^%s*(%d+):%d*")
    print("Line number: " .. (lnum or "nil")) -- Отладка
    if lnum then
      vim.cmd(lnum)
    end
  else
    print("File not found or no valid path under cursor: " .. (file or ""))
  end
end

return {
    is_weak_mode = is_weak_mode,
    apply_snippets = apply_snippets,
    open_file_under_cursor = open_file_under_cursor
}

