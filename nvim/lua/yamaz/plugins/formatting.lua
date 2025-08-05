return {
  "stevearc/conform.nvim",
  lazy = true,
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local conform = require("conform")
    conform.setup({
      formatters_by_ft = {
        javascript = { "eslint_d", "prettier" },
        typescript = { "eslint_d", "prettier"  },
        javascriptreact = { "eslint_d", "prettier" },
        typescriptreact = { "eslint_d", "prettier" },
        css = { "prettier" },
        html = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        graphql = { "prettier" },
        lua = { "stylua" },
      },
      formatters = {
        eslint_d = {
          command = vim.fn.stdpath("data") .. "/mason/bin/eslint_d",
          require_cwd = true, -- Требуем .eslintrc в рабочей директории
        },
      },
      log_level = vim.log.levels.DEBUG, -- Включаем отладку
    })
    -- formatting lsp (ts_ls)
    vim.keymap.set("n", "<leader>fl", vim.lsp.buf.format)

    -- formatting eslint_d 
    -- conform не может запустить форматирование через eslint_d
    vim.keymap.set({ "n", "v" }, "<leader>fe", function()
      local file = vim.fn.expand("%:p") -- Полный путь к текущему файлу
      local cmd = vim.fn.stdpath("data") .. "/mason/bin/eslint_d --fix " .. file
      vim.fn.system(cmd) -- Выполняем команду
      vim.cmd("edit!") -- Перезагружаем буфер для обновления изменений
      if vim.v.shell_error == 0 then
        vim.notify("Formatted with eslint_d", vim.log.levels.INFO)
      else
        vim.notify("eslint_d failed: " .. vim.fn.systemlist(cmd)[1], vim.log.levels.ERROR)
      end
    end, { desc = "Format file with eslint_d" })

    -- formatting prettier
    vim.keymap.set({ "n", "v" }, "<leader>fp", function()
      conform.format({
        lsp_fallback = true,
        async = true,
        timeout_ms = 1000,
      })
    end, { desc = "Format file or range (in visual mode)" })
  end,
}
