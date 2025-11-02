return {
    {
        "tpope/vim-dispatch",
        -- Опциональные настройки:
        lazy = true,                             -- для отложенной загрузки
        cmd = { "Dispatch", "Make", "Focus", "Start" }, -- загружать по командам
        -- config = function()
        --   -- Здесь можно добавить кастомные настройки, например:

        --   vim.g.dispatch_no_maps = 1 -- отключить дефолтные маппинги
        -- end,
    }
}
