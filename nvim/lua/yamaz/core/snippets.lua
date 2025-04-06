local snippets = {
    {
        key_map = "<leader>cl",
        desc = "Insert debug console.log",
        command = [[// eslint-disable-next-line no-console<CR>console.log('%chint', 'background-color: green', params);<CR><Esc>O]]
    },
    {
        key_map = "<leader>ce",
        desc = "Insert debug console.log error color",
        command = [[// eslint-disable-next-line no-console<CR>console.error('%cerror', 'background-color: red', params);<Esc>O]]
    },
    {
        key_map = "<leader>ci",
        desc = "Insert debug console.log info color",
        command = [[// eslint-disable-next-line no-console<CR>console.info('%cinfo', 'background-color: blue', params);<Esc>O]]
    },
    {
        key_map = "<leader>cf",
        desc = "Insert arrow function",
        command = [[const fn = (arguments) => {<CR>return <CR>}<Esc>]]
    }
}

return {
    snippets = snippets
}
