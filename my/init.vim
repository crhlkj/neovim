" ============================================================================
" Базовые Настройки
" ============================================================================
set number                  " Показывать номера строк
set relativenumber          " Показывать относительные номера строк
set cursorline              " Подсвечивает строку курсора
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
set cmdheight=1             " Высота командной строки
set nowrap                  " Отключить перенос строк на новую

" Производительность
set lazyredraw              " Не перерисовывать во время выполнения макросов
set ttyfast                 " Быстрая перерисовка в современных терминалах
set hidden                  " Разречить фоновые буферы

" ============================================================================
" Управление Плагинами (используя vim-plug)
" ============================================================================
call plug#begin('~/.config/nvim/plugins')
    
    " Цветовая схема
    Plug 'lucasadelino/conifer.nvim'

    " Строка состояния
    Plug 'nvim-lualine/lualine.nvim'
    Plug 'nvim-tree/nvim-web-devicons' " Иконки для 'Проводника файлов' и 'Lualine'

    " CoC (Conquer of Completion) - замена LSP
    Plug 'neoclide/coc.nvim', {'branch': 'release'}

    " Навигация по файлам и нечёткий поиск
    Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.5' }
    Plug 'nvim-lua/plenary.nvim'                " Необходим для Telescope

    " Подсветка синтаксиса
    Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
    Plug 'nvim-treesitter/playground'           " Песочница Treesitter для отладки

    " Проводник файлов
    Plug 'nvim-tree/nvim-tree.lua'

    " Строка вкладок
    Plug 'akinsho/bufferline.nvim', { 'tag': '*' }

    "  Xлебные крошки
    Plug 'Bekaboo/dropbar.nvim'

    " Управление Git
    Plug 'tpope/vim-fugitive'
    Plug 'lewis6991/gitsigns.nvim'

    " Автоматическое закрытие скобок
    Plug 'jiangmiao/auto-pairs'

    " Терминал внутри nvim
    Plug 'akinsho/toggleterm.nvim'

    " Подсказки по комбинации клавиши
    Plug 'folke/which-key.nvim'

call plug#end()
filetype indent off   " Отключить специфичные для типов файлов отступы
syntax on            " Включить подсветку синтаксиса

" ============================================================================
" Конфигурация Плагинов
" ============================================================================

" Цветовая схема
colorscheme conifer

lua << END
vim.g.mapleader = " "

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

-- Управление Git
require('gitsigns').setup({
  signs = {
    add = { text = '+' },
    change = { text = '~' },
    delete = { text = '_' },
  }
})

-- Навигация по изменениям
vim.keymap.set('n', ']c', function() require('gitsigns').next_hunk() end)
vim.keymap.set('n', '[c', function() require('gitsigns').prev_hunk() end)

-- Просмотр изменений
vim.keymap.set('n', '<leader>hp', function() require('gitsigns').preview_hunk() end)

-- Строка вкладок
require("bufferline").setup({
    options = {
        offsets = {
            {
                filetype = "NvimTree",
                text = "File Explorer", 
                highlight = "Directory", 
                separator = true, 
            }
        },
    }
})

-- Хлебные крошки | Перемещение
local dropbar_api = require('dropbar.api')
vim.keymap.set('n', '<Leader>;', dropbar_api.pick, { desc = 'Pick symbols in winbar' })
vim.keymap.set('n', '[;', dropbar_api.goto_context_start, { desc = 'Go to start of current context' })
vim.keymap.set('n', '];', dropbar_api.select_next_context, { desc = 'Select next context' })


-- Toggleterm
require('toggleterm').setup({
    open_mapping = [[<c-\>]],
    -- direction = 'float',
})

-- Lualine
require('lualine').setup({
    options = {
        icons_enabled = true,
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        disabled_filetypes = {},
        always_divide_middle = true,
        ignore_focus = { "NvimTree" },
    },
})

END

" ============================================================================
"  Конфигурация для coc.nvim
" ============================================================================

" Некоторые серверы имеют проблемы с резервными копиями, см. #649
set nobackup
set nowritebackup

" Увеличить время обновления диалогового окна (по умолчанию 4000 мс)
set updatetime=300

" Всегда показывать знак колонки
set signcolumn=yes

" Сделать <CR> принимать выбранное дополнение
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Применение AutoFix для проблемы на текущей строке
nmap <leader>qf  <Plug>(coc-fix-current)

" ============================================================================
" Горячие Клавиши
" ============================================================================
" Основная клавиша-модификатор
let mapleader = " "

" Выход из режима вставки
inoremap jk <ESC>

" Сохранение и выход
nnoremap <leader>w <CMD>:w!<CR>
nnoremap <leader>q <CMD>:q<CR>
nnoremap <leader>x <CMD>:x<CR>
"nnoremap <leader>r <CMD>:source $MYVIMRC<CR>

" Перемещение строк вверх/вниз
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" Горячие клавиши для Telescope
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

" Строка вкладок
nnoremap <S-l> <Cmd>BufferLineCycleNext<CR>
nnoremap <S-h> <Cmd>BufferLineCyclePrev<CR>

nnoremap <S-x> <Cmd>BufferLineCloseOthers<CR>

" Горячие клавиши для nvim-tree
nnoremap <leader>: <CMD>:NvimTreeToggle<CR>
nnoremap <leader>t <CMD>:NvimTreeFocus<CR>

" Базовые маппинги Fugitive
nnoremap <leader>gs :Git<CR>
nnoremap <leader>gc :Git commit<CR>
nnoremap <leader>gp :Git push<CR>
nnoremap <leader>gl :Git pull<CR>
nnoremap <leader>gd :Gdiff<CR>

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
"    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim 
"  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
"endif
