-- plugins/formatting.lua
-- С conform.nvim мало что меняется. Конфигурация та же.
local M = {}

function M.setup()
    local ok, conform = pcall(require, "conform")
    if not ok then return end

    conform.setup({
        formatters_by_ft = {
            javascript = { "prettier", "eslint_d", stop_after_first = true },
            typescript = { "prettier", "eslint_d", stop_after_first = true },
            javascriptreact = { "prettier", "eslint_d", stop_after_first = true },
            typescriptreact = { "prettier", "eslint_d", stop_after_first = true },
            css = { "prettier" },
            html = { "prettier" },
            json = { "prettier" },
            yaml = { "prettier" },
            markdown = { "prettier" },
            graphql = { "prettier" },
            lua = { "stylua" },
            go = { "goimports", "gofumpt" },
        },
        formatters = {
            eslint_d = {
                command = vim.fn.stdpath("data") .. "/mason/bin/eslint_d",
            },
            prettier = {
                command = vim.fn.stdpath("data") .. "/mason/bin/prettier",
            },
        },
        format_on_save = function(bufnr)
            local ft = vim.bo[bufnr].filetype
            if vim.tbl_contains({ "javascript", "typescript", "javascriptreact", "typescriptreact" }, ft) then
                return { formatters = { "prettier", "eslint_d" }, stop_after_first = true, timeout_ms = 5000, lsp_fallback = false }
            end
            return nil
        end,
        log_level = vim.log.levels.DEBUG,
    })

    local km = vim.keymap
    -- В 0.12 vim.lsp.buf.format принимает filter и bufnr
    km.set("n", "<leader>fl", vim.lsp.buf.format)

    km.set({ "n", "v" }, "<leader>fe", function()
        conform.format({ formatters = { "eslint_d" }, lsp_fallback = false, timeout_ms = 5000 })
    end, { desc = "Format file with eslint_d" })

    km.set({ "n", "v" }, "<leader>fp", function()
        conform.format({ lsp_fallback = true, async = true, timeout_ms = 1000 })
    end, { desc = "Format file or range (in visual mode)" })

    -- Предзапускаем eslint_d daemon для текущего проекта, чтобы conform не ждал
    -- холодного старта (~10-15с) при первом форматировании JS/TS файла.
    vim.api.nvim_create_autocmd("FileType", {
        pattern = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
        callback = function(args)
            local root = vim.fs.root(args.buf, "package.json")
            if not root then
                return
            end
            -- Запускаем холостой lint асинхронно; stderr нас не интересует.
            -- Используем callback, чтобы не блокировать event loop.
            local function warm_daemon()
                vim.system(
                    { vim.fn.stdpath("data") .. "/mason/bin/eslint_d", "--stdin", "--stdin-filename", vim.api.nvim_buf_get_name(args.buf) },
                    { cwd = root, stdin = "" },
                    function() end
                )
            end

            -- Если daemon уже есть, ничего не делаем. Иначе запускаем
            -- синхронный короткий статус и затем асинхронный warm.
            local status_ok, status_result = pcall(function()
                return vim.system(
                    { vim.fn.stdpath("data") .. "/mason/bin/eslint_d", "status" },
                    { cwd = root }
                ):wait(3000)
            end)
            if status_ok and status_result and (status_result.stdout or ""):match("Running") then
                return
            end
            warm_daemon()
        end,
        once = true,
    })
end

return M