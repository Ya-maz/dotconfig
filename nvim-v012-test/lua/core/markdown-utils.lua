-- core/markdown-utils.lua
-- Навигация по markdown/wiki ссылкам через <leader><CR>.
-- Сохраняет стандартный Vim <CR> в нормальном/вставном режимах.
local M = {}

local function open_file(target)
    if vim.fn.filereadable(target) == 1 or vim.fn.isdirectory(target) == 1 then
        vim.cmd("edit " .. vim.fn.fnameescape(target))
        return true
    end
    return false
end

local function resolve_link(link)
    if vim.startswith(link, "/") or vim.startswith(link, "~") then
        return vim.fn.expand(link)
    end
    local dir = vim.fn.expand("%:p:h")
    return vim.fn.fnamemodify(dir .. "/" .. link, ":p")
end

local function jump_to_header(anchor)
    local pattern = "\\V" .. anchor:gsub("^#+", "")
    local original = vim.o.ignorecase
    vim.o.ignorecase = true
    local found = vim.fn.search(pattern, "w")
    if found == 0 then
        vim.notify('Заголовок "' .. anchor .. '" не найден', vim.log.levels.WARN)
    end
    vim.o.ignorecase = original
end

local function follow_neowiki()
    local ok = pcall(function()
        require("neowiki.api").follow_link()
    end)
    return ok
end

local function extract_wikilink()
    local line = vim.fn.getline(".")
    local col = vim.fn.col(".")
    for wiki_target in line:gmatch("%[%[(.-)%]%]") do
        local start_pos, end_pos = line:find("%[%[" .. vim.pesc(wiki_target) .. "%]%]", 1, true)
        if start_pos and col >= start_pos and col <= end_pos then
            return wiki_target
        end
    end
    return nil
end

local function extract_markdown_link()
    local line = vim.fn.getline(".")
    for text, target in line:gmatch("%[(.-)%]%(([^%)]*)%)") do
        local start_pos, end_pos = line:find("[" .. vim.pesc(text) .. "](" .. vim.pesc(target) .. ")", 1, true)
        if start_pos and col >= start_pos and col <= end_pos then
            return target
        end
    end
    return nil
end

function M.link()
    if vim.bo.filetype ~= "markdown" then
        return
    end

    local col = vim.fn.col(".")

    -- Wikilink [[target]]
    local wiki_target = extract_wikilink()
    if wiki_target then
        follow_neowiki()
        return
    end

    -- Markdown link [text](target)
    local target = extract_markdown_link()
    if target then
        if target:match("^[a-zA-Z][a-zA-Z0-9+.-]*://") then
            vim.notify("Web-ссылки не поддерживаются: " .. target, vim.log.levels.WARN)
            return
        end

        if target:match("^#+") then
            jump_to_header(target)
            return
        end

        local resolved = resolve_link(target)
        if open_file(resolved) then
            return
        end

        -- Если .md файл не найден, пробуем через neowiki
        if target:match("%.md$") or target:match("%.txt$") then
            local neowiki_ok = follow_neowiki()
            if neowiki_ok then
                return
            end
        end

        vim.notify("Файл не существует: " .. resolved, vim.log.levels.ERROR)
        return
    end

    vim.notify("Ссылка не найдена под курсором", vim.log.levels.WARN)
end

return M
