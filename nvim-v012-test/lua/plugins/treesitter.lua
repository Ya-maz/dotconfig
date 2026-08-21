local M = {}

local languages = {
    "json", "javascript", "typescript", "tsx", "yaml", "html", "css",
    "markdown", "markdown_inline", "bash", "lua", "vim", "dockerfile",
    "gitignore", "query", "go", "gomod",
}

function M.setup()
    local ok, ts = pcall(require, "nvim-treesitter")
    if not ok then
        vim.notify("nvim-treesitter не загружен: " .. tostring(ts), vim.log.levels.WARN)
        return
    end

    -- Подсветка через нативный API 0.12
    vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("yamaz/ts-highlight", { clear = true }),
        callback = function(args)
            local lang = vim.treesitter.language.get_lang(args.match) or args.match
            pcall(vim.treesitter.start, args.buf, lang)
        end,
    })

    -- Incremental selection
    pcall(function()
        ts.setup({
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "<C-space>",
                    node_incremental = "<C-space>",
                    node_decremental = "<bs>",
                },
            },
        })
    end)

    -- Установить все настроенные парсеры (ручная команда).
    vim.api.nvim_create_user_command("TSInstallAll", function()
        ts.install(languages):wait()
    end, {
        desc = "Install all configured treesitter parsers",
    })
end

return M
