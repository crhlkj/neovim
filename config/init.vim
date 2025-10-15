" ============================================================================
" Базовые Настройки
" ============================================================================
set number                  " Показывать номера строк
set relativenumber          " Показывать относительные номера строк
set mouse=a                 " Включить поддержку мыши
set clipboard=unnamedplus   " Использовать системный буфер обмена (Linux/Windows)
set signcolumn=yes          " Всегда показывать колонку знаков (для диагностики/git)

" Настройки отступов
set tabstop=4
set shiftwidth=4
set expandtab               " Использовать пробелы вместо табуляции
set autoindent
set smartindent

" Поиск
set ignorecase
set smartcase               " Чувствительность к регистру при наличии заглавных букв
set hlsearch                " Подсвечивать результаты поиска
set incsearch               " Инкрементальный поиск

" Интерфейс
set termguicolors           " Включить поддержку истинного цвета
set background=dark         " Использовать тёмную тему
set showmode                " Показывать текущий режим
set showcmd                 " Показывать команды в нижней панели
set laststatus=2            " Всегда показывать строку состояния
set ruler                   " Показывать информацию о строке/колонке
set cmdheight=2             " Высота командной строки

" Производительность
set lazyredraw              " Не перерисовывать во время выполнения макросов
set ttyfast                 " Быстрая перерисовка в современных терминалах
set hidden                  " Разрешить фоновые буферы

" ============================================================================
" Управление Плагинами (используя vim-plug)
" ============================================================================
call plug#begin('~/.config/nvim/plugins')
    
    " Цветовая схема
    Plug 'folke/tokyonight.nvim'

    " Строка состояния
    Plug 'nvim-lualine/lualine.nvim'
    Plug 'nvim-tree/nvim-web-devicons' " Иконки для 'Проводника файлов' и 'Lualine'

    " Поддержка языков
    Plug 'neovim/nvim-lspconfig'                " Конфигурация LSP
    Plug 'hrsh7th/nvim-cmp'                     " Автодополнение
    Plug 'hrsh7th/cmp-nvim-lsp'                 " Источник LSP для nvim-cmp
    Plug 'hrsh7th/cmp-buffer'                   " Источник буфера для nvim-cmp
    Plug 'hrsh7th/cmp-path'                     " Источник путей для nvim-cmp
    Plug 'saadparwaiz1/cmp_luasnip'             " Поддержка сниппетов
    Plug 'L3MON4D3/LuaSnip'                     " Движок сниппетов
    Plug 'rafamadriz/friendly-snippets'         " Коллекция сниппетов

    " Навигация по файлам и нечёткий поиск
    Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.5' }
    Plug 'nvim-lua/plenary.nvim'                " Необходим для Telescope

    " Подсветка синтаксиса
    Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
    Plug 'nvim-treesitter/playground'           " Песочница Treesitter для отладки

    " Проводник файлов
    Plug 'nvim-tree/nvim-tree.lua' 

    " Автоматическое закрытие скобок
    Plug 'jiangmiao/auto-pairs'

    " Терминал внутри nvim
    Plug 'akinsho/toggleterm.nvim'

    " Статистика времени кодирования
    Plug 'wakatime/vim-wakatime'

call plug#end()
filetype indent off   " Отключить специфичные для типов файлов отступы
syntax on            " Включить подсветку синтаксиса

" ============================================================================
" Конфигурация Плагинов
" ============================================================================

" Цветовая схема
colorscheme tokyonight

lua << END

-- Treesitter
require'nvim-treesitter.configs'.setup {
    ensure_installed = { "vim" },
    sync_install = false,
    auto_install = true,
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
    indent = { enable = true }
}

-- Проводник файлов
require("nvim-tree").setup()

-- Настройка LSP
local nvim_lsp = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Настройка LSP серверов (установить серверы с помощью :LspInstall <server_name>)
local servers = {  }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    capabilities = capabilities,
    on_attach = function(client, bufnr)
      -- Включить дополнение по <c-x><c-o>
      vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
    end
  }
end

-- Настройка автодополнения
local cmp = require'cmp'
cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  }, {
    { name = 'buffer' },
    { name = 'path' },
  })
})

-- Toggleterm
require('toggleterm').setup({
    open_mapping = [[<c-\>]],
    -- direction = 'float',
})

-- Lualine
require('lualine').setup {
    options = {
        icons_enabled = true,
        theme = 'tokyonight',
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        disabled_filetypes = {},
        always_divide_middle = true,
        ignore_focus = { "NvimTree" },
    },
}

END

" ============================================================================
" Горячие Клавиши
" ============================================================================
" Основная клавиша-модификатор
let mapleader = " "

" Выход из режима вставки
inoremap jk <ESC>

" Сохранение и выход
nnoremap <leader>w <CMD>:w<CR>
nnoremap <leader>q <CMD>:q<CR>
nnoremap <leader>x <CMD>:x<CR>

" Перемещение строк вверх/вниз
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" Горячие клавиши для Telescope
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

" Горячие клавиши для nvim-tree
nnoremap <leader>e <CMD>:NvimTreeFocus<CR>
nnoremap <leader>t <CMD>:NvimTreeToggle<CR>

" Горячие клавиши для терминала
nnoremap <leader>tt <cmd>ToggleTerm<cr>
tnoremap <Esc> <C-\><C-n>

" Очистка подсветки поиска
nnoremap <silent> <leader>nh <CMD>:nohlsearch<CR>

" ============================================================================
" Установка плагинов при первом запуске
" ============================================================================
"if empty(glob(stdpath('data') . '/plugged/vim-plug'))
"  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
  "  \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim 
  "autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
"endif
