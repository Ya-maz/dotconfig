-- core/ensure-tools.lua
-- При старте проверяет наличие tree-sitter парсеров и Mason-пакетов.
-- Недостающие устанавливает асинхронно (чтобы не блокировать запуск).
local M = {}

-- Список должен совпадать с тем, что используется в конфиге
local ts_languages = {
    "json", "javascript", "typescript", "tsx", "yaml", "html", "css",
    "markdown", "markdown_inline", "bash", "lua", "vim", "dockerfile",
    "gitignore", "query", "go", "gomod",
}

local mason_packages = {
    -- LSP
    "gopls",
    "typescript-language-server",
    "html-lsp",
    "css-lsp",
    "json-lsp",
    "lua-language-server",
    -- Formatters / linters
    "prettier", "stylua", "eslint_d",
    "goimports", "gofumpt", "golangci-lint",
    -- Other
    "sonarlint-language-server",
}

local function notify(msg, level)
    vim.notify("[ensure-tools] " .. msg, level or vim.log.levels.INFO)
end

function M.ensure_treesitter_parsers()
    local ok, ts = pcall(require, "nvim-treesitter")
    if not ok then
        notify("nvim-treesitter не загружен", vim.log.levels.WARN)
        return
    end

    local missing = {}
    for _, lang in ipairs(ts_languages) do
        local has_parser = pcall(vim.treesitter.language.add, lang)
        if not has_parser then
            table.insert(missing, lang)
        end
    end

    if #missing == 0 then
        return
    end

    notify("Устанавливаю парсеры: " .. table.concat(missing, ", "))
    vim.defer_fn(function()
        local ok_install, err = pcall(function()
            ts.install(missing):wait(120000)
        end)
        if ok_install then
            notify("Парсеры установлены: " .. table.concat(missing, ", "))
        else
            notify("Ошибка установки парсеров: " .. tostring(err), vim.log.levels.ERROR)
        end
    end, 100)
end

function M.ensure_mason_packages()
    local ok, registry = pcall(require, "mason-registry")
    if not ok then
        notify("mason-registry не загружен", vim.log.levels.WARN)
        return
    end

    local missing = {}
    for _, pkg_name in ipairs(mason_packages) do
        local ok_pkg, pkg = pcall(registry.get_package, pkg_name)
        if ok_pkg and not pkg:is_installed() then
            table.insert(missing, pkg_name)
        end
    end

    if #missing == 0 then
        return
    end

    notify("Устанавливаю Mason-пакеты: " .. table.concat(missing, ", "))
    vim.defer_fn(function()
        for _, pkg_name in ipairs(missing) do
            local ok_pkg, pkg = pcall(registry.get_package, pkg_name)
            if ok_pkg and not pkg:is_installed() then
                if pkg:is_installing() then
                    notify("Уже устанавливается: " .. pkg_name)
                else
                    pkg:install():once("closed", function()
                        if pkg:is_installed() then
                            notify("Установлен: " .. pkg_name)
                        else
                            notify("Не удалось установить: " .. pkg_name, vim.log.levels.ERROR)
                        end
                    end)
                end
            end
        end
    end, 100)
end

function M.setup()
    M.ensure_treesitter_parsers()
    M.ensure_mason_packages()
end

return M
