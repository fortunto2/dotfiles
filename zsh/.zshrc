# ~/.zshrc - Dotfiles template
# Replace paths and values for your system

# Auto-switch to English in terminal
command -v im-select &>/dev/null && im-select com.apple.keylayout.ABC

# Homebrew paths (macOS)
export PATH="/opt/homebrew/opt/python@3.8/bin:$PATH"
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
export PATH="/opt/homebrew/opt/node@18/bin:$PATH"
export PATH="/usr/local/bin:$PATH"

# User local bins
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.poetry/bin:$PATH"

# Tab completion
autoload -Uz compinit && compinit
autoload -U +X bashcompinit && bashcompinit

# Better completion settings
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'  # case insensitive
setopt AUTO_MENU
setopt COMPLETE_IN_WORD

# Cargo (Rust)
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

# NVM (Node Version Manager)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Bun
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# Google Cloud (set your own project)
# export GOOGLE_CLOUD_PROJECT="your-project-id"
# export GOOGLE_CLOUD_LOCATION="us-central1"

# API keys - create ~/.secrets and source it
# Example ~/.secrets:
#   export GEMINI_API_KEY="your-key"
#   export AZURE_OPENAI_API_KEY="your-key"
[ -f "$HOME/.secrets" ] && source "$HOME/.secrets"
