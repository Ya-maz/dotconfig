-- plugins/fugitive-git.lua
local M = {}

-- В 3-way diff (Gvdiffsplit!) dp из бокового окна должен взять изменение
-- в рабочий файл. Fugitive предоставляет d2o/d3o из среднего окна.
-- Эта функция делает то же самое, но из левого/правого окна:
-- - в //2 (HEAD/ours) → diffget //2 в среднем окне
-- - в //3 (theirs)   → diffget //3 в среднем окне
local function diffput_to_working()
    local current_win = vim.api.nvim_get_current_win()
    local current_buf_name = vim.fn.bufname(vim.api.nvim_get_current_buf())

    local side = current_buf_name:match("//(%d)/")
    if not side then
        vim.notify("dp работает только в окнах fugitive //2 или //3", vim.log.levels.WARN)
        return
    end

    -- Находим среднее (рабочее) окно
    local middle_win = nil
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        if win ~= current_win then
            local buf = vim.api.nvim_win_get_buf(win)
            local name = vim.fn.bufname(buf)
            local is_diff = vim.api.nvim_get_option_value("diff", { win = win })
            if is_diff and not name:match("^fugitive://") then
                middle_win = win
                break
            end
        end
    end

    if not middle_win then
        vim.notify("Не найдено рабочее окно", vim.log.levels.WARN)
        return
    end

    -- Запоминаем позицию, переходим в среднее окно, на ближайший конфликт,
    -- берём нужную сторону и возвращаемся.
    local saved_view = vim.fn.winsaveview()
    vim.api.nvim_set_current_win(middle_win)
    vim.cmd("normal! ]c")
    vim.cmd("diffget //" .. side)
    vim.cmd("diffupdate")
    vim.api.nvim_set_current_win(current_win)
    vim.fn.winrestview(saved_view)
end

function M.setup()
    vim.keymap.set("n", "<leader>gs", vim.cmd.Git)

    -- В diff-режиме для fugitive-буферов //2 и //3 вешаем свой dp,
    -- который гарантированно кладёт изменение в рабочий файл.
    vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "fugitive://*//[23]/*",
        callback = function(args)
            if vim.api.nvim_get_option_value("diff", { win = 0 }) then
                vim.keymap.set("n", "dp", diffput_to_working, {
                    buffer = args.buf,
                    desc = "Put diff hunk into working file",
                })
            end
        end,
    })
end

return M