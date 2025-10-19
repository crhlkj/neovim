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
set cmdheight=2             " Высота командной строки

" Производительность
set lazyredraw              " Не перерисовывать во время выполнения макросов
set ttyfast                 " Быстрая перерисовка в современных терминалах
set hidden                  " Разречить фоновые буферы

" ============================================================================
" Управление Плагинами (используя vim-plug)
" ============================================================================
call plug#begin('~/.config/nvim/plugins')
    
    " Цветовая схема
    Plug 'folke/tokyonight.nvim'
    Plug 'KijitoraFinch/nanode.nvim'
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

    " Автоматическое закрытие скобок
    Plug 'jiangmiao/auto-pairs'

    " Терминал внутри nvim
    Plug 'akinsho/toggleterm.nvim'

call plug#end()
filetype indent off   " Отключить специфичные для типов файлов отступы
syntax on            " Включить подсветку синтаксиса

" ============================================================================
" Конфигурация Плагинов
" ============================================================================

" Цветовая схема
"colorscheme tokyonight
"colorscheme nanode
colorscheme conifer

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
" Конфигурация CoC.nvim
" ============================================================================

" Некоторые серверы имеют проблемы с резервными копиями, см. #649
set nobackup
set nowritebackup

" Увеличить время обновления диалогового окна (по умолчанию 4000 мс)
set updatetime=300

" Всегда показывать знак колонки
set signcolumn=yes

" Использовать Tab для автодополнения
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Сделать <CR> принимать выбранное дополнение
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Использовать <c-space> для запуска автодополнения
inoremap <silent><expr> <c-space> coc#refresh()

" Использовать `[g` и `]g` для навигации по диагностике
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Переходы по коду
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Использовать K для отображения документации в предпросмотре
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Подсветка символов и их документация
autocmd CursorHold * silent call CocActionAsync('highlight')

" Переименование символа
nmap <leader>rn <Plug>(coc-rename)

" Форматирование выделенного кода
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

" Применение codeAction к выделенной области
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Применение codeAction к текущему буферу
nmap <leader>ac  <Plug>(coc-codeaction)

" Применение AutoFix для проблемы на текущей строке
nmap <leader>qf  <Plug>(coc-fix-current)

" Запуск CodeLens действия на текущей строке
nmap <leader>cl  <Plug>(coc-codelens-action)

" Карта для организации импортов текущего буфера
nmap <silent> <leader>oi :call CocActionAsync('runCommand', 'editor.action.organizeImport')<CR>

" Показать все диагностики
nnoremap <silent><nowait> <space>d  :<C-u>CocList diagnostics<cr>

" Управление расширениями
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>

" Показать команды
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>

" Поиск символов текущего документа
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>

" Поиск по workspace символов
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>

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
nnoremap <leader>r <CMD>:source $MYVIMRC<CR>

" Перемещение строк вверх/вниз
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" Горячие клавиши для Telescope
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

" Горячие клавиши для nvim-tree
nnoremap <leader>: <CMD>:NvimTreeToggle<CR>
nnoremap <leader>t <CMD>:NvimTreeFocus<CR>

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
