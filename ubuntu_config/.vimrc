"config begin

"==========================================
" Pluges
"==========================================

call plug#begin('~/.vim/plugged')

" Theme
Plug 'rakr/vim-one'

" 状态栏
Plug 'vim-airline/vim-airline'
let g:airline_theme='one'

" 语法检测
Plug 'w0rp/ale'
let g:ale_sign_error = '✗'
let g:ale_sign_warning = '⚡'

" 左侧文件列表
Plug 'scrooloose/nerdtree'
" 自动启动 NERDTree
"autocmd vimenter * NERDTree
" 快捷键 Ctrl + T 启动 NERDTree
map <C-t> :NERDTreeToggle<CR>
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif
" 如果剩下的唯一窗口是 NERDTree，关闭 Vim
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" 高亮代码尾部的空格
Plug 'bronson/vim-trailing-whitespace'

" 显示缩进竖线
Plug 'nathanaelkane/vim-indent-guides'
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_auto_colors = 0
let g:indent_guides_guide_size = 1
let g:indent_guides_start_level = 2

"Plug 'github/copilot'
Plug 'itchyny/lightline.vim'
Plug 'NLKNguyen/papercolor-theme'
Plug 'wgwoods/vim-systemd-syntax'
Plug 'leafgarland/typescript-vim'
Plug 'xolox/vim-misc'
Plug 'xolox/vim-lua-ftplugin'
Plug 'pangloss/vim-javascript'
Plug 'airblade/vim-gitgutter'
Plug 'posva/vim-vue'
Plug 'alvan/vim-php-manual'
Plug 'cespare/vim-toml'
Plug 'godlygeek/tabular'
Plug 'kien/ctrlp.vim'
Plug 'mzlogin/vim-markdown-toc'
Plug 'plasticboy/vim-markdown'
"Plug 'roxma/vim-paste-easy'
Plug 'tmhedberg/matchit'
Plug 'tpope/vim-commentary'
""""""
Plug 'scrooloose/nerdtree', {'on': 'NERDTreeToggle'}

Plug 'alx741/vinfo'

" 插件有许多问题, 想要用起来实在不容易
" Plug 'winmanager'

Plug 'tpope/vim-fireplace'

" Vim开机画面
Plug 'mhinz/vim-startify'

Plug 'yegappan/mru'

Plug 'xolox/vim-session'
"Plug 'vim-misc'

"Plug 'jaxbot/chrome-devtools.vim'


Plug 'xuhdev/vim-latex-live-preview', {'on': []}



" Show git changes in file.
Plug 'airblade/vim-gitgutter'

" About Complete
" YouCompleteMe: cd ~/.vim/bundle/YouCompleteMe  && ./install.py --all
" 我自己的编译方式
" ./install.py --clang-completer --go-completer \
" --system-boost --system-libclang --clang-tidy \
"  --build-dir ~/Project/build-YCM
Plug 'Valloric/YouCompleteMe' ", {'on': []}

" Plug 'neoclide/coc.nvim', {'do': { -> coc#util#install()}}

" ToDo List Manager
" Plug 'vitalk/vim-simple-todo', {'on': []}

" For typescript
" Plug 'leafgarland/typescript-vim'

" AsyncRun 异步运行 Recommend to use Vim 8.0 or later.
" Plug 'skywind3000/asyncrun.vim'

" Evernote
" Plug 'kakkyz81/evervim', {'on': []}

" For mysql
" Plug 'mysqlguru/Vimsql', {'on': []}
" Plug 'cosminadrianpopescu/vim-sql-workbench', {'on': []}

" Plug 'ctrlpvim/ctrlp.vim'

" For Markdown
Plug 'plasticboy/vim-markdown'
" Plug 'Markdown'
" Plug 'Markdown-syntax'

" Airline变得再好看也是airline, 放弃了
" Plug 'bling/vim-airline'
" Plug 'vim-airline/vim-airline'
" Plug 'vim-airline/vim-airline-themes'

" VimWiki
" Plug 'vimwiki/vimwiki'
" Plug 'vimwiki/vimwiki', { 'branch': 'dev' }

" Work with tmux
" Plug 'benmills/vimux'

" For CMake
Plug 'jalcine/cmake.vim', {'for': 'cmake'}

" 很好很强大, 快速产生写好的代码片段
Plug 'MarcWeber/vim-addon-mw-utils'
Plug 'tomtom/tlib_vim'
Plug 'garbas/vim-snipmate'
Plug 'scrooloose/nerdtree', {'on': 'NERDTreeToggle'}

Plug 'honza/vim-snippets'
" For Git
Plug 'tpope/vim-fugitive', {'on': []}

" Show Marks
Plug 'kshenoy/vim-signature'

Plug 'vim-scripts/fcitx.vim'
Plug 'vim-scripts/taglist.vim'
Plug 'vim-scripts/L9'
Plug 'vim-scripts/css_color.vim'
Plug 'vim-scripts/vimdoc'
Plug 'vim-scripts/cscope.vim'
Plug 'vim-scripts/ZenCoding.vim'
Plug 'vim-scripts/JSON.vim', {'for': 'json'}
Plug 'vim-scripts/vcscommand.vim'
Plug 'vim-scripts/Workspace-Manager'

" For Latex
Plug 'vim-scripts/vimlatex'

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" For Java
" Plug 'javacomplete'
" Plug 'java_fold'
" Plug 'javaDoc.vim'

" Doxygen注释
" Plug 'DoxygenToolkit.vim'

" For Python
Plug 'vim-scripts/python.vim', {'for': 'python'}
Plug 'davidhalter/jedi-vim' ", {'for': 'python'}
Plug 'python-mode/python-mode', { 'branch': 'develop', 'for': 'python' }
Plug 'raimon49/requirements.txt.vim', {'for': 'requirements'}


Plug 'vim-scripts/SuperTab', {'on': []}
Plug 'vim-scripts/AutoClose'

Plug 'thaerkh/vim-workspace'

" For View
Plug 'vim-scripts/minibufexpl.vim'

" Some themes
" Plug 'crusoexia/vim-monokai'
" Plug 'jaromero/vim-monokai-refined'
Plug 'iCyMind/NeoSolarized'
" Plug 'altercation/vim-colors-solarized'
" Plug 'rakr/vim-one'

Plug 'vim-scripts/Tabular' " , {'on': 'Tabular'}
Plug 'Yggdroot/indentLine'

" Vim 异步语法检查
" This plugin requires Vim 8.0 or above to run, or NeoVim
"Plug 'w0rp/ale' ", {'on':[]}

" For Verilog
" Plug 'verilog.vim'

" For Spell
Plug 'vim-scripts/SpellCheck'

"For SCIP
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plug 'Olical/vim-scheme', { 'for': 'scheme', 'on': 'SchemeConnect' }

" You'll need vim-sexp too for selecting forms.
" Plug 'guns/vim-sexp'

" And while you're here, tpope's bindings make vim-sexp a little nicer to use.
" Plug 'tpope/vim-sexp-mappings-for-regular-people'
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""Plug 'SirVer/ultisnips'


call plug#end()
"==========================================
" General
"==========================================

" history存储长度。
set history=1000
" 检测文件类型
filetype on
" 针对不同的文件类型采用不同的缩进格式
filetype indent on
" 允许插件
filetype plugin on
" 启动自动补全filetype plugin indent on
" 非兼容vi模式。去掉讨厌的有关vi一致性模式，避免以前版本的一些bug和局限
set nocompatible
set autoread          " 文件修改之后自动载入。
set shortmess=atI       " 启动的时候不显示那个援助索马里儿童的提示

" 取消备份。
" Turn backup off, since most stuff is in SVN, git et.c anyway...
set nobackup
set nowb
set noswapfile

" 粘贴时保持格式
set paste
set smarttab                " 开启新行时使用智能 tab 缩进
set autoindent              " 设置自动缩进(即每行的缩进值与上一行相等)
set smartindent             " 设置智能缩进
" 点击光标不会换,用于复制
set mouse-=a           " 在所有的模式下面打开鼠标。
set selection=exclusive
set selectmode=mouse,key
" No annoying sound on errors
" 去掉输入错误的提示声音
set noerrorbells
set novisualbell
set t_vb=
set tm=500
"==========================================
" show and format
"==========================================
" 显示行号
set number
" 取消换行
set nowrap
" 使用相对行号
:set number relativenumber
"" 为方便复制，用<F2>开启/关闭行号显示:
nnoremap <F2> :set nonumber!<CR>:set foldcolumn=0<CR>
"" 自动切换相对行号和绝对行号
"autocmd WinEnter,FocusGained * :set number norelativenumber
"autocmd WinLeave,FocusLost   * :set number relativenumber

" 括号配对情况
set showmatch
" How many tenths of a second to blink when matching brackets
set mat=2

" 设置文内智能搜索提示
" 高亮search命中的文本。
set hlsearch
" 搜索时忽略大小写
set ignorecase
" 随着键入即时搜索
set incsearch
" 有一个或以上大写字母时仍大小写敏感
set smartcase
" 代码折叠
set foldenable
" 折叠方法
" manual    手工折叠
" indent    使用缩进表示折叠
" expr      使用表达式定义折叠
" syntax    使用语法定义折叠
" diff      对没有更改的文本进行折叠
" marker    使用标记进行折叠, 默认标记是 {{{ 和 }}}
set foldmethod=manual
" 在左侧显示折叠的层次
"set foldcolumn=4
set tabstop=4                " 设置Tab键的宽度        [等同的空格个数]
set shiftwidth=4
set expandtab                " 将Tab自动转化成空格    [需要输入真正的Tab键时，使用 Ctrl+V + Tab]
" 按退格键时可一次删掉 4 个空格
set softtabstop=4

set ai "Auto indent
set si "Smart indent

"==========================================
" status
"==========================================
" 显示当前的行号列号：
set ruler
" 在状态栏显示正在输入的命令
set showcmd

" Set 7 lines to the cursor - when moving vertically using j/k 上下滚动,始终在中间
set so=7
" 突出显示当前行
set cursorline
" 命令行（在状态行下）的高度，默认为1，这里是2
"set cmdheight=2
"set rulerformat=%20(%2*%<%f%=\ %m%r\ %3l\ %c\ %p%%%)
"set statusline=%F%m%r%h%w\[POS=%l,%v][%p%%]\%{strftime(\"%d/%m/%y\ -\ %H:%M\")}
set statusline=%<%f\ %h%m%r%=%k[%{(&fenc==\"\")?&enc:&fenc}%{(&bomb?\",BOM\":\"\")}]\ %-14.(%l,%c%V%)\ %P
" Always show the status line
"set laststatus=2
"==========================================
" Colors and fonts
"==========================================
"开启语法高亮
syntax enable
syntax on

" 设置配色方案
"colorscheme one
set background=dark
set termguicolors
set t_Co=256

" Set extra options when running in GUI mode
if has("gui_running")
    set guioptions-=T
    set guioptions+=e
    set t_Co=256
    set guitablabel=%M\ %t
endif
"set guifont=Monaco:h20          " 字体 && 字号
"==========================================
" File encode
"==========================================
" 设置新文件的编码为 UTF-8
"set fileencoding=utf8
"set enc=2byte-gb18030
" 自动判断编码时，依次尝试以下编码：
set fileencodings=ucs-bom,utf-8,gb18030,default
" gb18030 最好在 UTF-8 前面，否则其它编码的文件极可能被误识为 UTF-8

" Use Unix as the standard file type
set ffs=unix,dos,mac
" 如遇Unicode值大于255的文本，不必等到空格再折行。
set formatoptions+=m
" 合并两行中文时，不在中间加空格：
set formatoptions+=B
"==========================================
" Others
"==========================================

autocmd! bufwritepost _vimrc source % " vimrc文件修改之后自动加载。 windows。
autocmd! bufwritepost .vimrc source % " vimrc文件修改之后自动加载。 linux。


" 自动完成
set completeopt=longest,menu
" 增强模式中的命令行自动完成操作
set wildmenu
" Ignore compiled files
set wildignore=*.o,*~,*.pyc
" Python 文件的一般设置，比如不要 tab 等
autocmd FileType python set tabstop=4 shiftwidth=4 expandtab
" 自动补全配置
autocmd FileType python set omnifunc=pythoncomplete#Complete
" Return to last edit position when opening files (You want this!)
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif

" A buffer becomes hidden when it is abandoned
"set hid

" For regular expressions turn magic on
set magic
" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" pydiction 1.2 python auto complete
let g:pydiction_location = '~/.vim/tools/pydiction/complete-dict'
" defalut g:pydiction_menu_height == 15
let g:pydiction_menu_height = 20

" config end
let g:vim_markdown_folding_disabled = 1
let g:gitgutter_max_signs=10000

"
" syntastic
"
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_quiet_messages = { "level": "errors" }
let g:syntastic_go_checkers = ['golint', 'govet', 'errcheck']
let g:syntastic_mode_map = { 'mode': 'active', 'passive_filetypes': ['go'] }
"
" go-vim
"
let g:go_version_warning = 0
let g:go_fmt_autosave = 1
let g:go_fmt_command = "goimports"

let g:NERDTreeDirArrowExpandable  = '@'
" let g:NERDTreeNodeDelimiter       = "\u00a0"
let g:NERDTreeDirArrowCollapsible = '-'
let g:NERDTreeShowHidden          = 0
let g:NERDTreeBookmarksFile       = $HOME.'/.vimtmp/NerdBookmarks.txt'
let g:NERDTreeShowBookmarks       = 1
let g:NERDTreeShowFiles           = 1
let g:NERDTreeShowLineNumbers     = 0
let g:NERDTreeWinSize             = 29
let g:NERDTreeMinimalUI           = 1
let g:NERDTreeDirArrows           = 1
let g:NERDTreeIgnore              = [
            \ '.*\.class',
            \ '.*\.pyc',
            \ '.*\.chm',
            \ '.*\.ttf',
            \ '.*\.lnk',
            \ '.*\.cproj',
            \ '.*\.exe',
            \ '.*\.dll',
            \ '.*\.out',
            \ '.*\.files',
            \ '.*\.zip',
            \ '.*\.rar',
            \ '.*\.gif'
            \ ]
let g:NERDTreeIndicatorMapCustom = {
            \ "Modified"  : "✹",
            \ "Staged"    : "✚",
            \ "Untracked" : "✭",
            \ "Renamed"   : "➜",
            \ "Unmerged"  : "═",
            \ "Deleted"   : "✖",
            \ "Dirty"     : "✗",
            \ "Clean"     : "✔︎",
            \ "Unknown"   : "?"
            \ }
"
" ctrlp
"
" Making CtrlP.vim load 100x faster — A Tiny Piece of Vim — Medm
" https://medium.com/a-tiny-piece-of-vim/making-ctrlp-vim-load-100x-faster-7a722fae7df6#.emcvo89nx
let g:ctrlp_user_command = [
            \ '.git/',
            \ 'git --git-dir=%s/.git ls-files -oc --exclude-standard'
            \ ]
let g:ctrlp_match_window       = 'bottom,order:btt,min:5,max:5,results:10'
let g:ctrlp_cmd                = 'CtrlPMixed'
let g:ctrlp_mruf_default_order = 1
"
" utime.vim
"
let g:timeStampFormat = '170101'
let g:timeStampString = '%y%m%d'
let g:timeStampLeader = 'version'

