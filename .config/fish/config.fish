# The following lines were added by Docker Desktop to add commands to your PATH.
export PATH="$PATH:/Users/malewicz/.docker/bin"
# End of Docker Desktop section.

set -gx EDITOR nvim
set -g fish_greeting
set -gx MANPAGER 'nvim +Man!'
set -gx STARSHIP_CONFIG "$HOME/.config/starship/starship.toml"
set -gx PNPM_HOME "$HOME/Library/pnpm"
set -gx EZA_IGNORE 'node_modules|.git|.venv|__pycache__|.DS_Store|target|build|dist|bin|obj|.idea|.vscode|*.dll|*.exe|*.pdb|*.so|*.o|*.class|*.jar'

set -g fish_cursor_default block
set -g fish_cursor_insert block
set -g fish_cursor_replace_one block
set -g fish_cursor_replace block
set -g fish_cursor_visual block
set -g fish_cursor_external block

fish_add_path --move --path \
    "$HOME/.asdf/shims" \
    "$HOME/.bun/bin" \
    "$PNPM_HOME" \
    "$HOME/.local/bin" \
    "$HOME/.cargo/bin" \
    "$HOME/.dotnet/tools" \
    "$HOME/.docker/bin" \
    /opt/homebrew/bin \
    /opt/homebrew/sbin

if not status is-interactive
    return
end

set -g fish_color_command green --bold
set -g fish_color_param normal
set -g fish_color_valid_path normal

fish_vi_key_bindings

alias gu 'gh browse'
alias code codium
alias vim nvim
alias cat bat
alias ls 'eza --color=always --git --icons=always --no-filesize --no-time --no-user --no-permissions'
alias ll 'eza --color=always --git --icons=always --long'
alias la 'eza --color=always --git --icons=always --long --all'

set -gx FZF_DEFAULT_COMMAND 'fd --hidden --strip-cwd-prefix --exclude .git'
set -gx FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"
set -gx FZF_ALT_C_COMMAND 'fd --type=d --hidden --strip-cwd-prefix --exclude .git'
set -gx FZF_CTRL_T_OPTS "--preview 'bat -n --color=always --line-range :500 {}'"
set -gx FZF_ALT_C_OPTS "--preview 'eza --tree --color=always --ignore-glob=\"$EZA_IGNORE\" {}'"

if command -q fnm
    fnm env --use-on-cd --shell fish | source
end

if command -q zoxide
    zoxide init fish --cmd cd | source
end

if test -r /opt/homebrew/opt/fzf/shell/key-bindings.fish
    source /opt/homebrew/opt/fzf/shell/key-bindings.fish
end

bind \cx\ce edit_command_buffer
bind -M insert \cx\ce edit_command_buffer
bind \cx\cc copy_commandline_to_clipboard
bind -M insert \cx\cc copy_commandline_to_clipboard

if command -q starship
    starship init fish | source
end
