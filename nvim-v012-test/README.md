# Neovim 0.12 — тестовая конфигурация

Эта директория содержит **новую** конфигурацию Neovim, совместимую с
**Neovim 0.12** (вышла в 2026 году). Она написана на базе вашей старой
конфигурации (`~/.config/nvim/`) и служит для плавной миграции.

> ⚠️ **Тестовая!** Старая конфигурация НЕ затронута.
> При ошибках — удалите `~/.config/nvim-v012-test` и вернитесь к старой.

---

## Запуск

### Вариант 1: явно указать путь
```sh
nvim -u ~/.config/nvim-v012-test/init.lua
```

### Вариант 2: переменная окружения (рекомендуется)
```sh
NVIM_APPNAME=nvim-v012-test nvim
```

Это переключает Neovim на отдельную директорию для `data` и `state`.
Плагины будут ставиться в `~/.local/share/nvim-v012-test/site/pack/core/opt/`,
lockfile — в `~/.config/nvim-v012-test/nvim-pack-lock.json`.

Для удобства добавьте alias:
```sh
alias n12='NVIM_APPNAME=nvim-v012-test nvim'
```

---

## Ключевые изменения по сравнению с 0.11

| Было (0.11) | Стало (0.12) |
|---|---|
| `lazy.nvim` | **встроенный `vim.pack`** |
| `nvim-lspconfig` + `lspconfig.setup()` | **`vim.lsp.config()` + `vim.lsp.enable()`** |
| ручные `on_attach` для каждого сервера | **`LspAttach` autocmd** |
| `nvim-cmp` + `LuaSnip` | **`blink.cmp`** (рекомендуется) или встроенный `vim.lsp.completion` |
| `nvim-treesitter` v0.9.3 (`require("nvim-treesitter.configs").setup`) | **`nvim-treesitter` main** (новая версия) |
| `vim.diagnostic` + `sign_define` | `vim.diagnostic.config({ signs = true })` |
| встроенный `treesitter`-highlight для markdown отсутствовал | **включён по умолчанию** |
| ручные `:Undotree`, `:DiffTool` | встроенные `:Undotree`, `:DiffTool` |
| shelltemp default true | **`shelltemp default false`** |
| `gO`, `gra`, `grn`, `grr` — кастомные | **встроенные** `:help lsp-defaults` |

Подробный список: `:help news` внутри Neovim 0.12.

---

## Структура файлов

```
nvim-v012-test/
├── init.lua                  # Главный файл
├── nvim-pack-lock.json       # Lockfile (создаётся автоматически)
└── lua/
    ├── core/                 # Утилиты
    │   ├── markdown-utils.lua
    │   ├── init.lua
    │   └── set.lua
    └── plugins/              # Конфигурация плагинов
        ├── colorschema.lua
        ├── dressing.lua
        ├── lualine.lua
        ├── harpoon.lua
        ├── oil.lua
        ├── trouble.lua
        ├── telescope.lua
        ├── treesitter.lua
        ├── highlight-colors.lua
        ├── hlchunk.lua
        ├── comments.lua
        ├── neowiki.lua
        ├── nvim-tree.lua
        ├── nvim-cmp.lua      # заглушка (для сравнения со старой)
        ├── blink-cmp.lua     # новая (активная)
        ├── formatting.lua
        ├── linting.lua
        ├── fugitive-git.lua
        ├── vim-dispatch.lua
        ├── blame.lua
        ├── undotree.lua
        ├── spelunker.lua
        └── lsp/
            ├── lspconfig.lua # vim.lsp.config + vim.lsp.enable
            ├── mason.lua
            └── sonarlint.lua
```

---

## Первый запуск

1. **Запустите Neovim**:
   ```sh
   NVIM_APPNAME=nvim-v012-test nvim
   ```
   `vim.pack.add()` начнёт качать плагины (это может занять 1-2 минуты).
   Будет показан список плагинов для подтверждения.

2. **Установите парсеры treesitter**:
   ```vim
   :TSInstallSync lua javascript typescript html css json markdown bash yaml go
   ```

3. **Установите LSP-серверы**:
   ```vim
   :Mason
   ```
   Выберите нужные (ts_ls, gopls, html, cssls, jsonls, lua_ls).

4. **Установите инструменты форматирования**:
   ```vim
   :MasonInstall stylua prettier eslint_d goimports gofumpt
   ```

5. **Проверьте здоровье**:
   ```vim
   :checkhealth
   :checkhealth vim.lsp
   ```

---

## Управление плагинами (vim.pack)

### Обновить все плагины
```vim
:lua vim.pack.update()
```
Откроется буфер подтверждения. Нажмите `:write` для применения или `:quit` для отмены.

### Обновить один плагин
```vim
:lua vim.pack.update({ 'blink.cmp' })
```

### Удалить плагин
```vim
" 1. Удалите строку из init.lua в секции vim.pack.add({})
" 2. Перезапустите nvim (чтобы vim.pack увидел изменение)
:NvimRestart
" 3. Удалите с диска:
:lua vim.pack.del({ 'nvim-tree.lua' })
```

### Заморозить версию (не обновлять)
```lua
vim.pack.add({
    { src = gh("..."), version = "v1.5.2" },   -- точная версия (tag)
    { src = gh("..."), version = "main" },     -- ветка
    { src = gh("..."), version = vim.version.range("^1.0") },  -- semver-диапазон
})
```

---

## Что делать, если что-то сломалось

### `:checkhealth` показывает ошибки
Смотрите раздел по конкретному компоненту: `:checkhealth vim.lsp`,
`:checkhealth mason`, и т.д.

### Plugin не загружается
1. Проверьте lockfile: `cat ~/.config/nvim-v012-test/nvim-pack-lock.json`
2. Проверьте, что плагин скачался: `ls ~/.local/share/nvim-v012-test/site/pack/core/opt/`
3. Попробуйте удалить и поставить заново:
   ```vim
   :lua vim.pack.del({ 'plugin-name' })
   " Перезапустите nvim, vim.pack.add() переустановит
   ```

### blink.cmp не показывает completion
Проверьте, что:
- LSP-сервер запущен: `:LspInfo`
- Источник `lsp` включён в `sources.default`
- `vim.lsp.completion.enable()` был вызван (см. `plugins/lsp/lspconfig.lua`)

### Старая конфигурация (yamaz) затронута?
**Нет.** Эта директория полностью изолирована. Запускайте старую как
обычно, новую — через `NVIM_APPNAME=nvim-v012-test`.

---

## Дальнейшие шаги

1. Протестируйте неделю на простых проектах
2. Если всё ок — скопируйте `~/.config/nvim-v012-test/lua/plugins/`
   в новую рабочую конфигурацию
3. Обновите сам Neovim до 0.12 (AppImage/архив с сайта)
4. Когда будете готовы полностью переехать — замените
   `~/.config/nvim/` содержимым `~/.config/nvim-v012-test/`

Удачи! 🎉