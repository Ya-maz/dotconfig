-- plugins/blink-cmp.lua
-- ============================================================================
-- ВАЖНО: В Neovim 0.12 ЕСТЬ ВСТРОЕННОЕ COMPLETION через vim.lsp.completion.enable().
-- blink.cmp — рекомендованная альтернатива (быстрее, удобнее, типо-устойчивый fuzzy).
-- Этот файл конфигурирует blink.cmp для совместимости со старыми keymap'ами.
--
-- Для миграции с nvim-cmp: было { name = "nvim_lsp" }, { name = "luasnip" }, { name = "buffer" }, { name = "path" }.
-- В blink.cmp источники называются: "lsp", "snippets" (auto = "luasnip"/"vsnip"/"snippy"),
-- "buffer", "path" и др.
-- ============================================================================
local M = {}

function M.setup()
    local ok, blink = pcall(require, "blink-cmp")
    if not ok then
        vim.notify("blink.cmp не установлен: " .. tostring(blink), vim.log.levels.WARN)
        return
    end

    blink.setup({
        -- keymap'ы (аналогично старому cmp.mapping.preset.insert)
        keymap = {
            preset = "default",
            ["<C-k>"] = { "select_prev", "fallback" },
            ["<C-j>"] = { "select_next", "fallback" },
            ["<C-b>"] = { "scroll_documentation_up" },
            ["<C-f>"] = { "scroll_documentation_down" },
            ["<C-Space>"] = { "show", "show_documentation" },
            ["<C-e>"] = { "hide" },
            ["<C-y>"] = { "accept" },
            ["<CR>"] = { "accept", "fallback" },
            -- Tab/Shift+Tab как дополнительная навигация
            ["Tab"] = { "select_next", "fallback" },
            ["<S-Tab>"] = { "select_prev", "fallback" },
        },

        -- Сниппеты: blink.cmp умеет работать с native vim.snippet (встроен в 0.12)
        -- и с LuaSnip. Используем встроенный через friendly-snippets (есть в новой
        -- версии, конвертированные в vscode-формат).
        snippets = {
            expand = function(args)
                -- 0.12 имеет встроенный vim.snippet — fallback на LuaSnip, если он есть
                local luasnip_ok, luasnip = pcall(require, "luasnip")
                if luasnip_ok and luasnip.lsp_expand then
                    luasnip.lsp_expand(args.body)
                else
                    -- Использовать нативный vim.snippet
                    local snip_ok, snip = pcall(require, "blink.cmp.snippets")
                    if snip_ok then snip.expand(args.body) end
                end
            end,
        },

        -- Источники (sources)
        sources = {
            default = { "lsp", "snippets", "buffer", "path" },
            providers = {
                lsp = {
                    name = "LSP",
                    module = "blink.cmp.sources.lsp",
                    score_offset = 0,
                    async = true,
                },
                buffer = {
                    name = "Buffer",
                    module = "blink.cmp.sources.buffer",
                    score_offset = 0,
                },
                path = {
                    name = "Path",
                    module = "blink.cmp.sources.path",
                    score_offset = 0,
                },
                snippets = {
                    name = "Snippets",
                    module = "blink.cmp.sources.snippets",
                    score_offset = -10,
                },
            },
        },

        -- Внешний вид (аналог lspkind.cmp_format)
        appearance = {
            use_nvim_cmp_as_default = true,
        },
    })

    -- Загружаем friendly-snippets через встроенный loaders.
    -- В 0.12 — vim.pack ставит плагины в
    --   ~/.local/share/nvim-v012-test/site/pack/core/opt/friendly-snippets
    -- (для обычного nvim — в ~/.local/share/nvim/site/pack/core/opt/...).
    -- friendly-snippets поставляет .json файлы — blink.cmp умеет их читать.
    pcall(function()
        local snip = require("blink.cmp.sources.snippets")
        local paths = {
            vim.fs.joinpath(vim.fn.stdpath("data"), "site/pack/core/opt/friendly-snippets"),
            vim.fn.stdpath("config") .. "/snippets", -- пользовательские
        }
        pcall(snip.load, { paths = paths })
    end)
end

return M