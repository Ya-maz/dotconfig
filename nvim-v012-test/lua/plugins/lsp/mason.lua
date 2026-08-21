-- plugins/lsp/mason.lua
-- ============================================================================
-- mason.nvim по-прежнему нужен для УСТАНОВКИ серверов (типа stylua, gopls).
-- mason-lspconfig НЕ нужен в 0.12 — встроенный vim.lsp.enable() сам подхватывает
-- .lua файлы из lsp/ в runtimepath (которые кладёт nvim-lspconfig).
-- ============================================================================
local M = {}

function M.setup()
    local ok, mason = pcall(require, "mason")
    if not ok then return end

    mason.setup({
        ui = {
            icons = {
                package_installed = "✓",
                package_pending = "➜",
                package_uninstalled = "✗",
            },
        },
    })

    -- Добавляем Mason bin в PATH, чтобы vim.lsp.enable() находил LSP-серверы.
    local mason_bin = vim.fs.joinpath(vim.fn.stdpath("data"), "mason", "bin")
    local path_sep = package.config:sub(1, 1) == "/" and ":" or ";"
    if not vim.env.PATH:find(mason_bin, 1, true) then
        vim.env.PATH = mason_bin .. path_sep .. vim.env.PATH
    end

    local mti_ok, mason_tool_installer = pcall(require, "mason-tool-installer")
    if mti_ok then
        mason_tool_installer.setup({
            ensure_installed = {
                -- LSP
                "gopls",
                "typescript-language-server",
                "html-lsp",
                "css-lsp",
                "json-lsp",
                "lua-language-server",
                -- Formatters / linters
                "prettier",
                "stylua",
                "eslint_d",
                "goimports",
                "gofumpt",
                "golangci-lint",
                -- Other
                "sonarlint-language-server",
            },
        })
    end
end

return M