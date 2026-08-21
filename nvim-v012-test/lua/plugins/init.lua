local function is_weak_mode() return vim.g.weak_mode == 1 end
local function is_ultra_weak_mode() return vim.g.ultra_weak_mode == 1 end

local function gh(user_repo) return "https://github.com/" .. user_repo end

vim.pack.add({
    -- Минимальный набор
    { src = gh("nvim-tree/nvim-web-devicons"), name = "nvim-web-devicons" },

    -- Core UX
    { src = gh("stevearc/oil.nvim") },
    { src = gh("stevearc/dressing.nvim") },
    { src = gh("nvim-lualine/lualine.nvim") },
    { src = gh("folke/trouble.nvim") },
    { src = gh("ThePrimeagen/harpoon"), name = "harpoon", version = "harpoon2" },

    -- Цвета и подсветка
    { src = gh("folke/tokyonight.nvim") },
    { src = gh("brenoprata10/nvim-highlight-colors") },
    { src = gh("shellRaining/hlchunk.nvim") },

    -- Комментарии
    { src = gh("numToStr/Comment.nvim") },
    { src = gh("JoosepAlviste/nvim-ts-context-commentstring") },

    -- Поиск / навигация
    { src = gh("nvim-telescope/telescope.nvim") },
    { src = gh("nvim-lua/plenary.nvim") },
    { src = gh("nvim-telescope/telescope-fzf-native.nvim") },
    { src = gh("nvim-telescope/telescope-live-grep-args.nvim") },

    -- Treesitter
    { src = gh("nvim-treesitter/nvim-treesitter"), version = "main" },

    -- Файловый менеджер
    { src = gh("nvim-tree/nvim-tree.lua") },

    -- Git
    { src = gh("tpope/vim-fugitive") },
    { src = gh("f-person/git-blame.nvim") },

    -- Undo tree
    { src = gh("mbbill/undotree") },

    -- Spelunker
    { src = gh("kamykn/spelunker.vim") },

    -- Notes / Wiki
    { src = gh("echaya/neowiki.nvim") },
    { src = gh("tpope/vim-repeat") },

    -- LSP
    { src = gh("williamboman/mason.nvim") },
    { src = gh("WhoIsSethDaniel/mason-tool-installer.nvim") },
    { src = gh("neovim/nvim-lspconfig") },

    -- Линтер / форматтер
    { src = gh("mfussenegger/nvim-lint") },
    { src = gh("stevearc/conform.nvim") },

    -- Completion
    { src = gh("Saghen/blink.cmp"), version = "v1.10.2" },

    -- Snippets
    { src = gh("rafamadriz/friendly-snippets") },

    -- SonarLint
    { src = "https://gitlab.com/schrieveslaach/sonarlint.nvim" },
})

local function safe_setup(mod)
    local ok, m = pcall(require, mod)
    if not ok then
        vim.notify("Failed to load " .. mod .. ": " .. tostring(m), vim.log.levels.WARN)
        return
    end
    if type(m.setup) == "function" then
        local ok2, err = pcall(m.setup)
        if not ok2 then
            vim.notify("Failed to setup " .. mod .. ": " .. tostring(err), vim.log.levels.ERROR)
        end
    end
end

-- Цветовая схема — первой
safe_setup("plugins.colorschema")

-- Core UX
safe_setup("plugins.dressing")
safe_setup("plugins.lualine")
safe_setup("plugins.harpoon")
safe_setup("plugins.oil")
safe_setup("plugins.trouble")
safe_setup("plugins.telescope")
safe_setup("plugins.treesitter")
safe_setup("plugins.highlight-colors")
safe_setup("plugins.hlchunk")
safe_setup("plugins.comments")
safe_setup("plugins.neowiki")
safe_setup("plugins.nvim-tree")
safe_setup("plugins.blink-cmp")
safe_setup("plugins.formatting")
safe_setup("plugins.linting")
safe_setup("plugins.fugitive-git")
safe_setup("plugins.blame")
safe_setup("plugins.undotree")
safe_setup("plugins.spelunker")

-- LSP — в конце, только в нормальном режиме
if not is_weak_mode() and not is_ultra_weak_mode() then
    safe_setup("plugins.lsp.mason")
    safe_setup("plugins.lsp.lspconfig")
    safe_setup("plugins.lsp.sonarlint")
end

-- Фоновая проверка и установка недостающих инструментов (парсеры + Mason)
pcall(function()
    require("core.ensure-tools").setup()
end)
