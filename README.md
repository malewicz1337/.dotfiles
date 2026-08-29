# The Configuration Abyss

Personal, macOS-first dotfiles. The repository is the source of truth; files under `$HOME` are symlinks. A Linux base setup is included for shells, editors, Git, Starship, and tmux.

## Requirements

### macOS

Apple Silicon, macOS 13+, Xcode Command Line Tools, and Homebrew:

```bash
xcode-select --install
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"
```

### Linux

Install Homebrew's build prerequisites. Debian/Ubuntu example:

```bash
sudo apt-get update
sudo apt-get install -y build-essential procps curl file git
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
```

Use equivalent prerequisite packages on other distributions.

### Common command-line packages

```bash
brew install \
  bat eza fd fish fnm fzf gh git-delta lazygit \
  neovim ripgrep starship tmux vim
fnm install --lts
```

These provide the configured shell, editors, prompt, Git tooling, fuzzy search, Telescope search, previews, aliases, tmux, and Node/npm for Neovim's web tooling. Git and `make` are also required; Xcode CLT provides them on macOS, and the Linux prerequisites provide them on Linux.

### macOS applications

```bash
brew install --cask font-monaspice-nerd-font ghostty vscodium
brew install --cask nikitabobko/tap/aerospace
```

Ghostty uses `MonaspiceNe Nerd Font Mono`. VSCodium provides the Fish `code` alias.

## Install

```bash
export DOTFILES="$HOME/.dotfiles"
git clone https://github.com/malewicz1337/.dotfiles.git "$DOTFILES"
mkdir -p "$HOME/.config" "$HOME/.config/git"
```

Back up existing targets first. `ln -s` intentionally refuses to overwrite them.

### Common links: macOS and Linux

```bash
ln -s "$DOTFILES/.config/fish" "$HOME/.config/fish"
ln -s "$DOTFILES/.config/nvim" "$HOME/.config/nvim"
ln -s "$DOTFILES/.config/starship" "$HOME/.config/starship"
ln -s "$DOTFILES/.config/git/ignore" "$HOME/.config/git/ignore"

for file in .bash_profile .bashrc .gitconfig .hushlogin .profile .tmux.conf .vimrc; do
  ln -s "$DOTFILES/$file" "$HOME/$file"
done
```

### Additional macOS links

```bash
ln -s "$DOTFILES/.config/aerospace" "$HOME/.config/aerospace"
ln -s "$DOTFILES/.config/ghostty" "$HOME/.config/ghostty"
```

AeroSpace and this Ghostty configuration are macOS-specific. The retained WezTerm configuration is optional and not linked by default.

## Linux adjustments

Before using the common links on Linux or another account:

- Replace machine-specific Docker paths in `.profile` and `.config/fish/config.fish` with `$HOME/.docker/bin`.
- In `.tmux.conf`, set `default-shell` to the absolute result of `command -v fish`.
- In Neovim's `oil.lua`, point the local plugin directory to `$HOME/Desktop/oil-git.nvim`.
- In Neovim's `conform.lua`, point CSharpier to `$HOME/.dotnet/tools/csharpier`.
- Do not link AeroSpace or the macOS Ghostty configuration.

The remaining Fish, Bash, Starship, Git, Vim, Neovim, and tmux configuration is the Linux base.

## Bootstrap

### Fish

Add Fish's absolute path to `/etc/shells`, then make it the login shell:

```bash
FISH="$(command -v fish)"
grep -qxF "$FISH" /etc/shells || echo "$FISH" | sudo tee -a /etc/shells
chsh -s "$FISH"
```

### tmux

Install TPM, start tmux, then press `Ctrl-a` followed by `I`:

```bash
git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
```

TPM installs `tmux-open`, `tmux-resurrect`, and `tmux-continuum`.

### Neovim

The Oil integration requires a local checkout:

```bash
git clone https://github.com/malewicz1337/oil-git.nvim.git "$HOME/Desktop/oil-git.nvim"
nvim
```

`lazy.nvim` installs plugins declared under `.config/nvim/lua/malewicz/plugins/`; exact revisions are in `lazy-lock.json`. Use `:Lazy sync` and `:Mason` after first launch.

Mason automatically requests:

- Tools: `codelldb`, `clang-format`, `ormolu`, `prettier`, `biome`, `eslint_d`, `stylelint`, `stylua`, `golines`, `goimports`, `golangci_lint_ls`, `shfmt`.
- LSPs: `clangd`, `elixirls`, `hls`, `zls`, `csharp_ls`, `lua_ls`, `rust_analyzer`, `gopls`, `templ`, `bashls`, `ts_ls`, `tailwindcss`, `svelte`, `html`, `cssls`, `jsonls`.

Install language toolchains only as needed: Go provides `gofmt`, Rust provides `rustfmt`, Elixir provides `mix`, Zig provides `zigfmt`, and .NET provides CSharpier:

```bash
dotnet tool install --global csharpier
```

## Optional integrations

Fish detects `zoxide` and adds conventional paths for asdf, Bun, pnpm, Cargo, .NET tools, Docker, and OMP. Install the optional shell helpers with:

```bash
brew install zoxide asdf
```

Optional WezTerm setup:

```bash
brew install --cask wezterm font-meslo-lg-nerd-font
ln -s "$DOTFILES/.config/wezterm" "$HOME/.config/wezterm"
```

## Portability and secrets

Review `.profile`, Fish, tmux, Neovim's local plugin path, CSharpier path, Git identity, and global ignores before using another machine. Use `$HOME` instead of account-specific absolute paths.

SSH keys, GitHub CLI credentials, OMP state, Docker credentials, and other authenticated state are intentionally excluded.

## Verify

```bash
fish -n "$HOME/.config/fish/config.fish"
nvim --headless '+qall'
vim -Nu "$HOME/.vimrc" -n -es -c 'qa!'
tmux -L dotfiles-smoke -f "$HOME/.tmux.conf" new-session -d
tmux -L dotfiles-smoke kill-server
TERM=xterm-256color STARSHIP_CONFIG="$HOME/.config/starship/starship.toml" starship prompt
git config --global user.name
```

On macOS, also run:

```bash
aerospace reload-config
/Applications/Ghostty.app/Contents/MacOS/ghostty +show-config
```

## License

Released under the [MIT License](LICENSE).
