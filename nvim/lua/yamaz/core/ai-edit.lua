local M = {}

function M.ai_edit()
  local mode = vim.fn.mode(true)
  if not (mode == "v" or mode == "V" or mode == "\22") then
    print("Ошибка: нужно выделить код в visual mode")
    return
  end

  local start_line = vim.fn.line("'<")
  local end_line = vim.fn.line("'>")
  local code_lines = vim.fn.getline(start_line, end_line)
  local code = table.concat(code_lines, "\n")

  local task = vim.fn.input("Что изменить в коде: ")
  if task == "" then
    print("Задача отменена")
    return
  end

  -- Отладка: покажем, что отправляем
  print("Отправляем в aichat...")
  print("Код (" .. #code_lines .. " строк):")
  print(code)
  print("Задача: " .. task)

  local input_text = table.concat({
    "'''CODE'''",
    code,
    "'''CODE'''",
    "",
    "'''TASK'''",
    task,
    "'''TASK'''"
  }, "\n")


  local cmd = {
    "aichat",
    "-r", "%nvim-code-edit%",
    "--",
    input_text
  }

  local new_code = vim.fn.system(cmd)

  -- КЛЮЧЕВОЙ МОМЕНТ: покажем, что вернул aichat
  if vim.v.shell_error ~= 0 then
    print("ОШИБКА выполнения aichat (код " .. vim.v.shell_error .. "):")
    print(new_code)
    return
  end

  if not new_code or new_code == "" then
    print("aichat вернул пустой результат")
    return
  end

  print("AI вернул новый код (" .. #vim.split(new_code, "\n") .. " строк):")
  print(new_code)

  local new_lines = vim.split(new_code, "\n", { trimempty = true })

  vim.api.nvim_buf_set_lines(0, start_line - 1, end_line, false, new_lines)
  print("Код успешно заменён!")
end

return M
