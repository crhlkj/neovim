# NeoVim
Конфигурация для программирования в NeoVim.

## Содержание
  - [`config/init.vim`](config/init.vim) - Стандаротный конфиг на LSP (`mason` + `cmp` + `lspconfig`)
  - [`config/coc.vim`](config/coc.vim) - Стандартный конфиг на `coc.nvim`
---
  - [`my/init.vim`](my/init.vim) - Личный конфиг с `coc.nvim`

## Дополнительно установка
- `Node.js` - Для установки LSP сервером
  - **Установка в Linux:**
    - ```bash
      sudo [type: pacman, apt ...] [type: -S, install ...] nodejs npm
      ```
- `Python` - Для установки также некоторых LSP которых нету в `node.js`
  - **Установка в Linux:**
    - ```bash
      sudo [type: pacman, apt ...] [type: -S, install ...] python3 pip3
      ```
