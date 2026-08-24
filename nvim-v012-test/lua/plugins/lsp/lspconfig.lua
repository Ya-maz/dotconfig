-- plugins/lsp/lspconfig.lua
-- ============================================================================
-- НОВЫЙ подход в Neovim 0.12:
--   1. Нативный vim.lsp.config('server_name', { ... }) — конфигурация сервера.
--   2. vim.lsp.enable('server_name') — автоматический attach к filetype.
--   3. LspAttach autocmd — bind keymap'ов ПОСЛЕ attach.
-- ============================================================================
-- Что осталось от nvim-lspconfig: только каталог с дефолтными конфигами
-- (`lsp/<server>.lua`), который ищется в runtimepath. Мы используем
-- nvim-lspconfig как "базу знаний" дефолтов, а сами конфигурируем
-- через vim.lsp.config (он "win").
--
-- Это работает потому, что nvim-lspconfig кладёт файлы в rtp/lsp/<server>.lua,
-- которые vim.lsp.config умеет мерджить (см. :help lsp-config-merge).
-- ============================================================================
local M = {}

function M.setup()
    -- 0.12: ВСТРОЕННЫЕ keymap'ы (gra, grn, grr, grt, grx, gO, i_CTRL-S).
    -- См. :help lsp-defaults. Они работают из коробки, но мы добавляем
    -- ПРИВЫЧНЫЕ keymap'ы для telescope на буфер после attach.

    vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("yamaz-lsp-attach", { clear = true }),
        callback = function(ev)
            local client = vim.lsp.get_client_by_id(ev.data.client_id)
            if not client then return end

            local buf = ev.buf
            local opts = { buffer = buf, noremap = true, silent = true }

            -- Свои keymap'ы (как раньше)
            vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<CR>",
                vim.tbl_extend("force", opts, { desc = "Show LSP references" }))
            vim.keymap.set("n", "gD", vim.lsp.buf.declaration,
                vim.tbl_extend("force", opts, { desc = "Go to declaration" }))
            vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>",
                vim.tbl_extend("force", opts, { desc = "Show LSP definitions" }))
            vim.keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>",
                vim.tbl_extend("force", opts, { desc = "Show LSP implementations" }))
            vim.keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>",
                vim.tbl_extend("force", opts, { desc = "Show LSP type definitions" }))
            vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action,
                vim.tbl_extend("force", opts, { desc = "See available code actions" }))
            vim.keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>",
                vim.tbl_extend("force", opts, { desc = "Show buffer diagnostics" }))
            vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float,
                vim.tbl_extend("force", opts, { desc = "Show line diagnostics" }))
            vim.keymap.set("n", "[d", vim.diagnostic.goto_prev,
                vim.tbl_extend("force", opts, { desc = "Go to previous diagnostic" }))
            vim.keymap.set("n", "]d", vim.diagnostic.goto_next,
                vim.tbl_extend("force", opts, { desc = "Go to next diagnostic" }))
            -- 0.12: K уже маппится автоматически (если не было кастомного mapping).
            -- Но у нас в remap есть свой — оставляем как есть.
            vim.keymap.set("n", "K", vim.lsp.buf.hover,
                vim.tbl_extend("force", opts, { desc = "Show documentation for what is under cursor" }))
            vim.keymap.set("n", "<leader>rs", ":LspRestart<CR>",
                vim.tbl_extend("force", opts, { desc = "Restart LSP" }))
        end,
    })

    -- ==============================================================
    -- 0.12: Конфигурируем LSP-серверы через vim.lsp.config + vim.lsp.enable.
    -- Маппинг имён из mason-lspconfig → новые конфиги.
    -- ==============================================================

    -- Глобальные настройки для ВСЕХ серверов
    vim.lsp.config("*", {
        -- root_markers — глобальный фолбэк
        root_markers = { ".git", "package.json", ".eslintrc", ".luarc.json" },
        capabilities = vim.lsp.protocol.make_client_capabilities(),
    })

    -- HTML
    vim.lsp.config("html", {
        filetypes = { "html", "templ" },
    })

    -- TypeScript/JavaScript (использует typescript-language-server, в mason это ts_ls)
    vim.lsp.config("ts_ls", {
        filetypes = {
            "javascript", "javascriptreact", "typescript", "typescriptreact",
            "javascript.jsx", "typescript.tsx",
        },
    })

    -- CSS / SCSS / LESS — обычно один сервер cssls
    vim.lsp.config("cssls", {
        filetypes = { "css", "scss", "less" },
    })

    -- JSON
    vim.lsp.config("jsonls", {
        filetypes = { "json", "jsonc" },
    })

    -- Go
    vim.lsp.config("gopls", {
        filetypes = { "go", "gomod" },
        settings = {
            gopls = {
                analyses = { unusedparams = true },
                staticcheck = true,
                gofumpt = true,
            },
        },
    })

    -- Lua
    vim.lsp.config("lua_ls", {
        filetypes = { "lua" },
        settings = {
            Lua = {
                diagnostics = { globals = { "vim" } },
                workspace = {
                    library = {
                        [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                        [vim.fn.stdpath("config") .. "/lua"] = true,
                    },
                },
            },
        },
    })

    -- Включаем все серверы разом (через встроенную функцию)
    vim.lsp.enable({
        "html",
        "ts_ls",
        "cssls",
        "jsonls",
        "gopls",
        "lua_ls",
    })

    -- blink.cmp обрабатывает автодополнение самостоятельно.
    -- Включать встроенное vim.lsp.completion.enable() не нужно,
    -- иначе два completion engine конфликтуют.
end

return M