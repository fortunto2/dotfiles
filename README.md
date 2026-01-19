# Dotfiles for Claude Code Development

Minimal terminal setup optimized for working with Claude Code AI assistant.

```
┌─────────────────┬─────────────────┐
│                 │                 │
│    Terminal     │   Claude Code   │
│    (work)       │                 │
│                 │                 │
└─────────────────┴─────────────────┘
```

## Features

- **Kitty** - Fast GPU-accelerated terminal with splits
- **Neovim** - File tree, git integration, syntax highlighting
- **tmux** - Optional session persistence
- **Warm theme** - No blue light, better for eyes at night
- **Russian keyboard support** - Hotkeys work on both layouts

## Quick Install

```bash
git clone https://github.com/YOUR_USERNAME/dotfiles.git
cd dotfiles
./scripts/install.sh
```

## Manual Install

### 1. Install dependencies (macOS)

```bash
brew install kitty neovim tmux ripgrep fd git
brew install --cask font-jetbrains-mono-nerd-font
brew tap daipeihust/tap && brew install im-select
```

### 2. Copy configs

```bash
# Kitty
mkdir -p ~/.config/kitty
cp kitty/* ~/.config/kitty/

# Neovim
mkdir -p ~/.config/nvim
cp nvim/init.lua ~/.config/nvim/

# tmux (optional)
cp tmux/tmux.conf ~/.tmux.conf

# zsh
cp zsh/zshrc ~/.zshrc
```

### 3. Install Claude Code

```bash
npm install -g @anthropic-ai/claude-code
```

## Hotkeys

### Kitty

| Hotkey | Action |
|--------|--------|
| `Cmd+D` | Vertical split |
| `Cmd+Shift+D` | Horizontal split |
| `Cmd+W` | Close split |
| `Cmd+Shift+W` | Close tab (all splits) |
| `Cmd+K` | Open Claude Code |
| `Cmd+E` | File tree (nvim) |
| `Ctrl+Tab` | Next split |
| `Cmd+[` / `Cmd+]` | Prev/next split |
| `Cmd+T` | New tab |
| `Cmd+1/2/3` | Switch tabs |

### Neovim (Space = leader)

| Hotkey | Action |
|--------|--------|
| `Space e` | Toggle file tree |
| `Space ff` | Find files |
| `Space fg` | Search text (grep) |
| `Space fb` | Open buffers |
| `Space gs` | Git status |
| `Space gD` | Git diff view |
| `Space gb` | Git blame |
| `q` or `Ctrl+C` | Quit nvim |
| `gcc` | Comment line |
| `gc` (visual) | Comment selection |

### tmux (Ctrl+A = prefix)

| Hotkey | Action |
|--------|--------|
| `Ctrl+A \|` | Vertical split |
| `Ctrl+A -` | Horizontal split |
| `Alt+Arrows` | Switch panes (no prefix) |
| `Ctrl+A d` | Detach session |
| `Ctrl+A r` | Reload config |

## File Structure

```
dotfiles/
├── kitty/
│   ├── kitty.conf      # Main config
│   ├── tab_bar.py      # Custom tab bar with hints
│   └── startup.conf    # Default layout
├── nvim/
│   └── init.lua        # Neovim config with plugins
├── tmux/
│   └── tmux.conf       # tmux config
├── zsh/
│   └── zshrc           # Shell config
├── scripts/
│   └── install.sh      # Auto-install script
└── README.md
```

## Customization

### Change theme colors

Edit `kitty/kitty.conf` - look for "Theme" section.

### Change tab bar hints

Edit `kitty/tab_bar.py` - modify the `HINTS` variable.

### Add more languages to syntax highlighting

Edit `nvim/init.lua` - find `ensure_installed` in treesitter config.

## Troubleshooting

### Hotkeys don't work with Russian layout

All main hotkeys have Russian equivalents (e.g., `Cmd+D` and `Cmd+В`).

### Icons look broken

Install Nerd Font:
```bash
brew install --cask font-jetbrains-mono-nerd-font
```

### Neovim plugins not loading

Run inside nvim:
```
:Lazy sync
```

## License

MIT
