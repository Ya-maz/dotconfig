-- plugins/formatting.lua
-- С conform.nvim мало что меняется. Конфигурация та же.
local M = {}

function M.setup()
    local ok, conform = pcall(require, "conform")
    if not ok then return end

    conform.setup({
        formatters_by_ft = {
            javascript = { "eslint_d", "prettier" },
            typescript = { "eslint_d", "prettier" },
            javascriptreact = { "eslint_d", "prettier" },
            typescriptreact = { "eslint_d", "prettier" },
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
                require_cwd = true,
            },
        },
        log_level = vim.log.levels.DEBUG,
    })

    local km = vim.keymap
    -- В 0.12 vim.lsp.buf.format принимает filter и bufnr
    km.set("n", "<leader>fl", vim.lsp.buf.format)

    km.set({ "n", "v" }, "<leader>fe", function()
        local file = vim.fn.expand("%:p")
        local cmd = vim.fn.stdpath("data") .. "/mason/bin/eslint_d --fix " .. file
        vim.fn.system(cmd)
        vim.cmd("edit!")
        if vim.v.shell_error == 0 then
            vim.notify("Formatted with eslint_d", vim.log.levels.INFO)
        else
            vim.notify("eslint_d failed: " .. vim.fn.systemlist(cmd)[1], vim.log.levels.ERROR)
        end
    end, { desc = "Format file with eslint_d" })

    km.set({ "n", "v" }, "<leader>fp", function()
        conform.format({ lsp_fallback = true, async = true, timeout_ms = 1000 })
    end, { desc = "Format file or range (in visual mode)" })
end

return M