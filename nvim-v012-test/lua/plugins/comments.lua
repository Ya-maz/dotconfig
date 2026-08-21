-- plugins/comments.lua
-- В 0.12 есть ВСТРОЕННЫЙ комментер (:help commenting), но старый
-- Comment.nvim с ts-context-commentstring лучше работает для JSX/TSX.
local M = {}

function M.setup()
    local ok, comment = pcall(require, "Comment")
    if not ok then return end

    local ctx_ok, ts_context = pcall(require, "ts_context_commentstring.integrations.comment_nvim")
    local pre_hook = ctx_ok and ts_context.create_pre_hook() or nil

    comment.setup({
        pre_hook = pre_hook,
    })
end

return M