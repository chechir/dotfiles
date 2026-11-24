call plug#begin()
Plug 'dense-analysis/ale'
Plug 'scrooloose/nerdtree'
Plug 'kien/ctrlp.vim'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && npx --yes yarn install' }
Plug 'bronson/vim-trailing-whitespace'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'pixelneo/vim-python-docstring'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'gruvbox-community/gruvbox'
" SQL
Plug 'tpope/vim-dadbod'
Plug 'kristijanhusak/vim-dadbod-ui'
Plug 'kristijanhusak/vim-dadbod-completion'
" Formatting (linting is ALE, above)
Plug 'stevearc/conform.nvim'
" Git
Plug 'sindrets/diffview.nvim'
Plug 'NeogitOrg/neogit'
Plug 'lewis6991/gitsigns.nvim'
" Editing
Plug 'MagicDuck/grug-far.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate', 'branch': 'master'}
Plug 'nvim-treesitter/nvim-treesitter-textobjects', {'branch': 'master'}
Plug 'nvim-treesitter/nvim-treesitter-context'
Plug 'Wansmer/treesj'
Plug 'chrisgrieser/nvim-spider'
call plug#end()

runtime base_init.vim

" silent! so a fresh install, before :PlugInstall, starts without errors
silent! colorscheme gruvbox

set nowrap
set textwidth=86
set suffixesadd+=.py
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.idea/*,*/.DS_Store,*/venv/*,*/.ipynb_checkpoints

" noselect: the completion menu never inserts an item you didn't pick
set completeopt=menuone,noselect,popup
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
autocmd InsertLeave * pclose!

" CtrlP: search from home, open in a new tab on Enter
nnoremap <Space>f :CtrlP ~<CR>
let g:ctrlp_prompt_mappings = {
    \ 'AcceptSelection("e")': ['<c-t>'],
    \ 'AcceptSelection("t")': ['<cr>', '<2-LeftMouse>'],
    \ }
let g:ctrlp_custom_ignore = 'mlruns'

" ALE: lint with the same tools as pre-commit
let g:ale_linters = {
    \   'python': ['flake8', 'mypy'],
    \   'r': ['lintr'],
    \}
let g:ale_python_mypy_options = '--ignore-missing-imports'
let g:ale_set_highlights = 1

let g:html_indent_script1 = "inc"
let g:html_indent_style1 = "inc"
let g:html_indent_inctags = "html,body,head"

" Gitsigns
nnoremap <leader>hp :Gitsigns preview_hunk<CR>
nnoremap <leader>hb :Gitsigns blame_line<CR>
nnoremap <leader>hs :Gitsigns stage_hunk<CR>
nnoremap <leader>hu :Gitsigns undo_stage_hunk<CR>
nnoremap <leader>hr :Gitsigns reset_hunk<CR>
nnoremap ]c :Gitsigns next_hunk<CR>
nnoremap [c :Gitsigns prev_hunk<CR>

nnoremap <leader>fr :GrugFar<CR>

lua << EOF
-- Python completion via the built-in LSP and pyright (installed by the Brewfile)
vim.lsp.config('pyright', {
  cmd = { 'pyright-langserver', '--stdio' },
  filetypes = { 'python' },
  root_markers = { 'pyproject.toml', 'setup.cfg', 'setup.py', '.git' },
  -- Diagnostics come from ALE (flake8, mypy) to match pre-commit
  handlers = { ['textDocument/publishDiagnostics'] = function() end },
})
vim.lsp.enable('pyright')
vim.diagnostic.config({ virtual_text = true })

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    vim.lsp.completion.enable(true, args.data.client_id, args.buf, { autotrigger = true })
  end,
})

-- Plugins may be missing on a fresh install, before :PlugInstall
local function plugin(name)
  local ok, mod = pcall(require, name)
  return ok and mod or nil
end

local gitsigns = plugin('gitsigns')
if gitsigns then
  gitsigns.setup({
    current_line_blame = true,
    current_line_blame_opts = { delay = 500, virt_text_pos = 'eol' },
  })
end

-- Format on save
local conform = plugin('conform')
if conform then
  conform.setup({
    formatters_by_ft = {
      python = { 'isort', 'black' },
      r = { 'styler' },
      sql = { 'sqlfluff' },
    },
    formatters = {
      -- Accept "unfixable violations remain"
      sqlfluff = { exit_codes = { 0, 1, 2 } },
    },
    format_after_save = { lsp_fallback = true },
  })
end

local grug_far = plugin('grug-far')
if grug_far then
  grug_far.setup({})
end

local treesj = plugin('treesj')
if treesj then
  treesj.setup({ use_default_keymaps = false })
  vim.keymap.set('n', '<leader>j', treesj.toggle, { desc = 'Split/join' })
end

local treesitter = plugin('nvim-treesitter.configs')
if treesitter then
  treesitter.setup({
    ensure_installed = { 'python', 'sql', 'bash', 'lua', 'vim', 'vimdoc', 'json', 'yaml', 'markdown' },
    auto_install = true,
    highlight = { enable = true },
    indent = { enable = true },
    textobjects = {
      select = {
        enable = true,
        lookahead = true,
        keymaps = {
          ['af'] = '@function.outer',
          ['if'] = '@function.inner',
          ['ac'] = '@class.outer',
          ['ic'] = '@class.inner',
          ['aa'] = '@parameter.outer',
          ['ia'] = '@parameter.inner',
          ['ai'] = '@conditional.outer',
          ['ii'] = '@conditional.inner',
          ['al'] = '@loop.outer',
          ['il'] = '@loop.inner',
        },
      },
      move = {
        enable = true,
        set_jumps = true,
        goto_next_start = { [']m'] = '@function.outer', [']]'] = '@class.outer' },
        goto_previous_start = { ['[m'] = '@function.outer', ['[['] = '@class.outer' },
      },
      swap = {
        enable = true,
        swap_next = { ['<leader>sa'] = '@parameter.inner' },
        swap_previous = { ['<leader>sA'] = '@parameter.inner' },
      },
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = '<C-space>',
        node_incremental = '<C-space>',
        node_decremental = '<bs>',
        scope_incremental = '<C-s>',
      },
    },
  })
end

local context = plugin('treesitter-context')
if context then
  context.setup({ max_lines = 3 })
end

-- snake_case / camelCase aware word motions
local spider = plugin('spider')
if spider then
  spider.setup({ skip_insignificant_punctuation = true })
  for _, motion in ipairs({ 'w', 'e', 'b', 'ge' }) do
    vim.keymap.set({ 'n', 'o', 'x' }, motion, function() spider.motion(motion) end)
  end
end
EOF

" Machine-specific settings (database connections etc.). Never committed.
if filereadable(expand('~/.vimrc.local'))
  source ~/.vimrc.local
endif
