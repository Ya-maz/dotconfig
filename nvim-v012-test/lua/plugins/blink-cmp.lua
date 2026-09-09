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

        -- Сниппеты: используем встроенный vim.snippet из Neovim 0.12.
        -- friendly-snippets подключается через источник snippets (см. providers ниже).
        snippets = {
            preset = "default",
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
                    score_offset = 10,
                    opts = {
                        friendly_snippets = true,
                        search_paths = {
                            vim.fs.joinpath(vim.fn.stdpath("data"), "site/pack/core/opt/friendly-snippets"),
                            vim.fn.stdpath("config") .. "/snippets",
                        },
                    },
                },
            },
        },

        -- Внешний вид (аналог lspkind.cmp_format)
        appearance = {
            use_nvim_cmp_as_default = true,
        },
    })
end

return M