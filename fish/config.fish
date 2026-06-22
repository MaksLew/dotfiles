if status is-interactive
    eval (starship init fish)
end

set -g fish_greeting ''

alias ..="cd .."
alias ...="cd ../.."
alias :q="exit"
alias zlj="zellij"
alias cd="z"
alias ff="fastfetch"
alias n="nvim"
alias nv="nvim"
alias vim="nvim"
alias nivm="nvim"
alias l="eza -l --icons=auto --group-directories-first --git --no-permissions --no-user --no-time"
alias la="eza -la --icons=auto --group-directories-first --git --no-permissions --no-user --no-time"
alias ls="eza -l --icons=auto --group-directories-first --git --total-size --no-permissions --no-user"
alias lsa="eza -l --icons=auto --group-directories-first --git --total-size --no-permissions --no-user"

export EDITOR=nvim
fish_config theme choose catppuccin-mocha
set fish_color_valid_path

set -gx SHELL /usr/bin/fish

zoxide init fish | source
jj util completion fish | source
