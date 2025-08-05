local M = {}

M.snippets = {
    {
        mode = "n",
        key_map = "<leader>log",
        command = [[i// eslint-disable-next-line no-console<CR>console.log('%chint', 'background-color: green', params);<CR><Esc>O]],
        desc = "Insert debug console.log"
    },
    {
        mode = "n",
        key_map = "<leader>arr",
        command = [[iconst fn = (arguments) => {<CR>return <CR>}<Esc>]],
        desc = "Insert arrow function"
    }
}

return M
