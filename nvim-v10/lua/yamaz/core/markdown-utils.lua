local M = {}

local function warn_notification(message)
	vim.notify(message, vim.log.levels.WARN)
end

local function open_markdown_link(link)
	if vim.fn.filereadable(link) == 1 then
		vim.cmd("edit " .. link)
	else
		vim.notify("Файл " .. link .. " не существует", vim.log.levels.ERROR)
	end
end

local function jump_to_markdown_header(anchor)
	-- Формируем шаблон поиска с \V для буквального соответствия
	local pattern = "\\V" .. anchor
	-- Сохраняем текущее значение ignorecase
	local original_ignorecase = vim.o.ignorecase
	-- Устанавливаем ignorecase для поиска без учёта регистра
	vim.o.ignorecase = true

	local current_line = vim.fn.line(".")
	local found = vim.fn.search(pattern, "w") -- 'w' включает обёртывание
	if found == 0 then
		warn_notification('Заголовок "' .. anchor .. '" не найден в файле')
	elseif found == current_line then
		-- Если нашли на текущей строке, ищем следующее совпадение
		found = vim.fn.search(pattern, "w")
		if found == 0 then
			warn_notification("Других совпадений не найдено")
		end
	end

	-- Восстанавливаем ignorecase
	vim.o.ignorecase = original_ignorecase
end

function M.link()
	if vim.bo.filetype ~= "markdown" then
		return
	end

	local line = vim.fn.getline(".")
	local link = line:match("%[.*%]%(([^%)]*)%)")

	if not link then
		warn_notification("Ссылка не найдена под курсором")
		return
	end

	if link:match("%.md$") then
		open_markdown_link(link)
	elseif link:match("^#+") then
		jump_to_markdown_header(link)
	else
		warn_notification("Неподдерживаемый тип ссылки")
	end
end

return M
