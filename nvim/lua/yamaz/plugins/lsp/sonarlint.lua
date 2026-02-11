return {
    "https://gitlab.com/schrieveslaach/sonarlint.nvim",
    dependencies = { "neovim/nvim-lspconfig" },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        local mason_path = vim.fn.stdpath("data") .. "/mason/packages/sonarlint-language-server"
        local analyzers_path = mason_path .. "/extension/analyzers"
        
        -- Устанавливаем токен в окружение
        vim.env.SONAR_TOKEN = "squ_d0f62c868125ccab83c3264185a5d56cd29301ed"

        -- SonarLint требует явного указания путей к jar-файлам.
        local analyzers = {
            vim.fn.expand(analyzers_path .. "/sonarjs.jar"),
            vim.fn.expand(analyzers_path .. "/sonarhtml.jar"),
            vim.fn.expand(analyzers_path .. "/sonarxml.jar"),
            vim.fn.expand(analyzers_path .. "/sonarpython.jar"),
        }

        local sonarlint_config = {
            server = {
                cmd = {
                    "sonarlint-language-server",
                    "-stdio",
                    "-analyzers",
                    unpack(analyzers),
                },
                settings = {
                    sonarlint = {
                        connectedMode = {
                            connections = {
                                sonarqube = {
                                    {
                                        connectionId = "rshb-sonar",
                                        serverUrl = "https://sonarqube.rshbdev.ru",
                                        token = vim.env.SONAR_TOKEN
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
                handlers = {
                    ["sonarlint/reportConnectionCheckResult"] = function(_, params, ctx)
                        local client = vim.lsp.get_client_by_id(ctx.client_id)
                        if not client then return end
                        
                        if params.success == false then
                            vim.notify(
                                "SonarLint: Connection failed (" .. (params.reason or "Unknown error") .. "). Press <leader>st to retry.",
                                vim.log.levels.ERROR,
                                { title = "SonarLint" }
                            )
                        else
                            vim.notify("SonarLint: Connected to " .. (params.connectionId or "server"), vim.log.levels.INFO, { title = "SonarLint" })
                        end
                    end,
                }
            },
            filetypes = {
                "javascript",
                "typescript",
                "javascriptreact",
                "typescriptreact",
                "python",
                "html",
            },
        }

        -- Инициализация при старте
        require("sonarlint").setup(sonarlint_config)

        -- Вспомогательная функция для получения клиентов (совместимость с 0.10+)
        local get_lsp_clients = function(opts)
            if vim.lsp.get_clients then
                return vim.lsp.get_clients(opts)
            else
                return vim.lsp.get_active_clients(opts)
            end
        end

        -- 1. Улучшенный Toggle <leader>st
        vim.keymap.set("n", "<leader>st", function()
            local sonarlint = require("sonarlint")
            local clients = get_lsp_clients({ name = "sonarlint.nvim" })
            
            if #clients > 0 then
                for _, c in ipairs(clients) do
                    vim.lsp.stop_client(c.id)
                end
                -- ОЧИЩАЕМ ВНУТРЕННИЙ КЭШ ПЛАГИНА
                sonarlint._client_id_by_root_dir = {}
                vim.notify("SonarLint stopped & cache cleared", vim.log.levels.WARN, { title = "SonarLint" })
            else
                sonarlint.setup(sonarlint_config)
                -- Принудительно вызываем FileType для текущего буфера
                vim.cmd("doautocmd FileType " .. vim.bo.filetype)
                vim.notify("SonarLint started", vim.log.levels.INFO, { title = "SonarLint" })
            end
        end, { desc = "Toggle SonarLint" })

        -- 2. Инфо-панель <leader>sd
        vim.keymap.set("n", "<leader>sd", function()
            local clients = get_lsp_clients({ name = "sonarlint.nvim" })
            if #clients == 0 then
                vim.notify("SonarLint is NOT running", vim.log.levels.WARN, { title = "SonarLint Status" })
                return
            end

            local client = clients[1]
            local is_attached = vim.lsp.buf_is_attached(0, client.id)
            
            -- Получаем диагностики именно от SonarLint
            local ns = vim.lsp.diagnostic.get_namespace(client.id)
            local diags = vim.diagnostic.get(0, { namespace = ns })
            
            local status_icon = is_attached and "✅ Attached" or "❌ Not Attached"
            local msg = string.format(
                "Server: Active (ID: %d)\nFile Status: %s\nIssues found: %d",
                client.id,
                status_icon,
                #diags
            )
            
            vim.notify(msg, vim.log.levels.INFO, { 
                title = "SonarLint Diagnostic",
                timeout = 5000 
            })
        end, { desc = "SonarLint Diagnostic Info" })
    end,
}
