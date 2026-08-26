-- plugins/lsp/sonarlint.lua
-- Используем sonarlint.nvim (уже установлен через vim.pack).
-- Плагин сам передаёт initializationOptions и обработчики сервера.
local M = {}

function M.setup()
    local ok, sonarlint = pcall(require, "sonarlint")
    if not ok then
        vim.notify("sonarlint.nvim не загружен: " .. tostring(sonarlint), vim.log.levels.WARN)
        return
    end

    local mason_path = vim.fn.stdpath("data") .. "/mason/packages/sonarlint-language-server"
    local analyzers_path = mason_path .. "/extension/analyzers"

    -- Токен SonarQube. В production лучше читать из env, а не хранить в git.
    vim.env.SONAR_TOKEN = "squ_d0f62c868125ccab83c3264185a5d56cd29301ed"

    sonarlint.setup({
        server = {
            cmd = {
                "sonarlint-language-server",
                "-stdio",
                "-analyzers",
                vim.fn.expand(analyzers_path .. "/sonarjs.jar"),
                vim.fn.expand(analyzers_path .. "/sonarhtml.jar"),
                vim.fn.expand(analyzers_path .. "/sonarxml.jar"),
                vim.fn.expand(analyzers_path .. "/sonarpython.jar"),
            },
        },
        filetypes = {
            "javascript",
            "typescript",
            "javascriptreact",
            "typescriptreact",
            "python",
            "html",
        },
        settings = {
            sonarlint = {
                connectedMode = {
                    connections = {
                        sonarqube = {
                            {
                                connectionId = "rshb-sonar",
                                serverUrl = "https://sonarqube.rshbdev.ru",
                            },
                        },
                    },
                    project = {
                        connectionId = "rshb-sonar",
                        projectKey = "rshbintech-it-corp-rprul-43121",
                    },
                },
            },
        },
        connected = {
            get_credentials = function(_, url)
                return vim.env.SONAR_TOKEN
            end,
        },
    })
end

return M
