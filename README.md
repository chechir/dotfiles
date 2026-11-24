# dotfiles

A terminal setup for Python and SQL work on macOS: zsh with oh-my-zsh, tmux, and Neovim
with LSP completion, format on save and linting that matches pre-commit.

## What's inside

| Path | Linked to | What it is |
|---|---|---|
| `zsh/zshrc` | `~/.zshrc` | oh-my-zsh, history, PATH |
| `zsh/aliases` | `~/.aliases` | venv and Python shortcuts |
| `tmux/tmux.conf` | `~/.tmux.conf` | `Ctrl-a` prefix, vim-style pane moves, mouse, macOS clipboard |
| `nvim/` | `~/.config/nvim` | Neovim config, plugins via [vim-plug](https://github.com/junegunn/vim-plug) |
| `git/` | `~/.gitconfig` etc. | aliases and a pretty `git l` log |
| `sql/sqlfluff` | `~/.sqlfluff` | SQL formatting rules |
| `Brewfile` | | CLI tools installed by Homebrew |

## Install

Needs macOS and [Homebrew](https://brew.sh).

```bash
git clone https://github.com/chechir/dotfiles.git ~/git/dotfiles
cd ~/git/dotfiles
make all
```

Or run one piece at a time:

```bash
make help     # list targets
make shell    # brew packages, oh-my-zsh, vim-plug, tmux plugin manager, symlinks
make python   # black, isort, flake8, mypy, pre-commit, sqlfluff, ipython, poetry via pipx
```

Then open a new terminal, start `tmux` and press `Ctrl-a I` to install the tmux plugins.

Re-running is safe. Any existing file that would be replaced is moved to
`<file>.backup.<timestamp>` first, so you can always go back.

## Your own settings and secrets

Nothing personal lives in this repo. Put machine-specific settings in these files; they
are loaded if present and never committed:

| File | For |
|---|---|
| `~/.zshrc.local` | API keys, tokens, extra PATH entries, work aliases |
| `~/.gitconfig.local` | `user.name`, `user.email`, credential helpers |
| `~/.vimrc.local` | database connections for vim-dadbod, extra mappings |

`make shell` copies your current git name and email into `~/.gitconfig.local`. To set
them by hand:

```bash
git config --file ~/.gitconfig.local user.name "Your Name"
git config --file ~/.gitconfig.local user.email "you@example.com"
```

Example `~/.vimrc.local`:

```vim
let g:dbs = { 'bq': 'bigquery:my-project' }
```

If a tool edits `~/.gitconfig` (for example `gh auth setup-git`), the change lands in
this repo through the symlink. Move those lines to `~/.gitconfig.local`.

## Cheat sheet

tmux (prefix `Ctrl-a`)

| Keys | Action |
|---|---|
| `Ctrl-b` / `Ctrl-n` | split vertically / horizontally |
| `Ctrl-q` | small split below |
| `Ctrl-h/j/k/l` | move between panes |
| prefix `H/J/K/L` | resize pane |
| prefix `s` | type into all panes at once |
| prefix `r` | reload config |

Neovim (leader `,`)

| Keys | Action |
|---|---|
| `Space f` | find file (CtrlP) |
| `,fr` | find and replace across files |
| `,j` | split or join a code block |
| `,hp` `,hs` `,hr` | preview, stage, reset git hunk |
| `]c` `[c` | next, previous git hunk |
| `af` `if` `ac` `aa` | select function, class, argument (treesitter) |
| `]m` `[m` | next, previous function |
| `Ctrl-space` | grow selection |
| `kk` | leave insert mode and save |
| `db` | insert a breakpoint |

Built into Neovim, no config needed

| Keys | Action |
|---|---|
| `K` | hover docs |
| `Ctrl-]` | go to definition |
| `grn` `grr` `gra` | rename, find references, code actions |
| `[d` `]d` | previous, next error |
| `gqq` `gq}` | wrap line, paragraph to `textwidth` |
| `:set spell!` | toggle spellcheck |

Surround ([vim-surround](https://github.com/tpope/vim-surround))

| Keys | Action |
|---|---|
| `ysiw"` | quote the word under the cursor |
| `yss"` | quote the whole line |
| `S"` | quote the visual selection |
| `ds"` | delete the quotes |

Replace across files without a plugin:

```vim
:vimgrep /old_name/ **/*.sql
:cfdo %s/old_name/new_name/g | update
```

`:MarkdownPreview` opens the current Markdown file in the browser.

Python files are formatted with isort and black on save, and linted with flake8 and mypy.

## Lint this repo

```bash
pre-commit install
make lint
```

## License

[MIT](LICENSE)
