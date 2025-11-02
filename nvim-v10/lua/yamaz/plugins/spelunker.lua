return {
    {
        "kamykn/spelunker.vim",
        config = function()
            vim.g.spelunker_highlight_type = 2       -- Подсвечивать только ошибки
            vim.g.spelunker_complex_orphan_check = 1 -- Искать опечатки в коде
            vim.g.spelunker_max_suggestions = 10     -- Ограничить количество предложений
            vim.g.enable_spelunker_vim = 1           -- Включить Spelunker автоматически
            vim.g.spelunker_check_type = 1           -- Проверять только строки (не комментарии)
            vim.g.spelunker_white_list_for_user = {
                'kamykn',
                'vimrc',
                'yamaz',
                'eslint',
                'classnames',
                'guid',
                'rshb',
                'ILOV',
                'ILOVItem'
            }
        end
    }
}
