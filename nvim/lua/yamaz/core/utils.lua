-- Функция для проверки режима
-- В системе есть alias такого вида
-- alias nn='nvim --cmd "let g:weak_mode = 1"'
local function is_weak_mode()
    return vim.g.weak_mode == 1
end

-- Функция для загрузки кастомных сниппетов из JSON-файла
-- 
-- local load_custom_snippets = function(luasnip)
--   local file_path = vim.fn.expand("~/.config/nvim/snippets.json")  -- Полный путь к файлу
--   local file = io.open(file_path, "r")  -- Открываем файл для чтения
--   if not file then
--     vim.notify("Не удалось открыть файл сниппетов: " .. file_path, vim.log.levels.ERROR)
--     return {}
--   end
--
--   local content = file:read("*a")  -- Читаем содержимое файла
--   file:close()
--
--   -- Парсим JSON (используем vim.fn.json_decode)
--   local ok, snippets = pcall(vim.fn.json_decode, content)
--   if not ok or not snippets then
--     vim.notify("Ошибка при парсинге JSON или сниппеты отсутствуют: " .. snippets, vim.log.levels.ERROR)
--     return {}
--   end
--
--   print('snippets', snippets)
--   -- Преобразуем JSON-сниппеты в формат LuaSnip
--   local luasnip_snippets = {}
--   for name, body in pairs(snippets) do
--     if type(body) == "table" then
--       -- Преобразуем массив строк в одну строку
--       body = table.concat(body, "\n")
--     end
--     if type(body) == "string" then  -- Проверяем, что body — это строка
--       table.insert(luasnip_snippets, luasnip.parser.parse_snippet(name, body))
--     else
--       vim.notify("Некорректный сниппет: " .. name, vim.log.levels.WARN)
--     end
--   end
--
--   return luasnip_snippets
-- end
--
-- Для проверки загрузки сниппета
-- :lua local luasnip = require("luasnip") local snippet = luasnip.get_snippets("typescript")["typescriptReactArrowFunctionComponent"] if snippet then print("Сниппет 'typescriptReactArrowFunctionComponent' загружен") else print("Сниппет 'typescriptReactArrowFunctionComponent' не найден") end

return {
    is_weak_mode = is_weak_mode,
    -- load_custom_snippets = load_custom_snippets
}
