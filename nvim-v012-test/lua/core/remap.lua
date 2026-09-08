local keymap = vim.keymap

keymap.set("v", "J", ":m '>+2<CR>gv=gv")
keymap.set("v", "K", ":m '<-2<CR>gv=gv")

keymap.set("n", "<leader>sa", "gg<S-v>G")

keymap.set("n", "ss", ":split<Return><C-w>w")
keymap.set("n", "sv", ":vsplit<Return><C-w>w")

keymap.set("n", "fwh", "<C-w>h")
keymap.set("n", "fwj", "<C-w>j")
keymap.set("n", "fwk", "<C-w>k")
keymap.set("n", "fwl", "<C-w>l")

keymap.set("n", "<M-n>", "<C-w><")
keymap.set("n", "<M-.>", "<C-w>>")
keymap.set("n", "<M-,>", "<C-w>+")
keymap.set("n", "<M-m>", "<C-w>-")

keymap.set("n", "J", "mzJ`z")

keymap.set("n", "<C-d>", "<C-d>zz")
keymap.set("n", "<C-e>", "<C-u>zz")
keymap.set("n", "n", "nzzzv")
keymap.set("n", "N", "Nzzzv")

keymap.set("x", "<leader>p", "\"_dP")
keymap.set({ "n", "v" }, "<leader>y", [["+y]])
keymap.set("n", "<leader>Y", [["+Y]])
keymap.set({ "n", "v" }, "<leader>d", [[_d]])

keymap.set("n", "<C-q>", ":bdelete<Return><C-w>w")

keymap.set("n", "<C-n>", "<cmd>cnext<CR>zz")
keymap.set("n", "<C-m>", "<cmd>cprev<CR>zz")

keymap.set("n", "<leader>b", ":ls<cr>:b<space>")

keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
keymap.set("n", "<leader>r", [[:cdo s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })
keymap.set("n", "<leader><leader>x", "<cmd>source %<CR>")
keymap.set("n", "<leader><leader>", function()
    vim.cmd("so")
end)

keymap.set("n", "<leader>rn", function()
    local file_name = vim.api.nvim_buf_get_name(0)
    local file_type = vim.bo.filetype
    print(file_name, file_type)
    if file_type == "lua" then
        vim.cmd(":terminal lua " .. file_name)
    elseif file_type == "javascript" then
        vim.cmd(":terminal node " .. file_name)
    end
end)

keymap.set("n", "<esc>", ":nohlsearch<CR>", { noremap = true, silent = true })

keymap.set("v", "<", "<gv", { silent = true, noremap = true })
keymap.set("v", ">", ">gv", { silent = true, noremap = true })

keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" })
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" })
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" })
keymap.set("n", "<leader>tt", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" })
keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" })

-- Удобное переключение табов по кругу одной клавишей
keymap.set("n", "<Tab>", function()
    local tabcount = vim.fn.tabpagenr("$")
    if tabcount == 1 then
        return
    end
    vim.cmd("tabnext")
end, { desc = "Next tab (cycles forward)" })

keymap.set("n", "<S-Tab>", function()
    local tabcount = vim.fn.tabpagenr("$")
    if tabcount == 1 then
        return
    end
    vim.cmd("tabprevious")
end, { desc = "Previous tab (cycles backward)" })

local job_id = 0
keymap.set("t", "<leader>q", "<C-\\><C-n>", { silent = true })
-- keymap.set("n", "<leader>st", function()
--     vim.cmd.vnew()
--     vim.cmd.term()
--     vim.cmd.wincmd("J")
--     job_id = vim.bo.channel
-- end)
-- keymap.set("n", "<leader>test", function()
--     vim.fn.chansend(job_id, { "npm run test \r\n" })
-- end)
-- keymap.set("n", "<leader>style", function()
--     vim.fn.chansend(job_id, { "npx stylelint src/apps/**/**.scss --fix \r\n" })
-- end)
