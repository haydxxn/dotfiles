export PATH=/Users/hayden/.local/bin:$PATH
export PATH="$PATH:/Users/hayden/.dotnet/tools"
export LSCOLORS="exfxcxdxbxegedabagacad"

eval "$(zoxide init zsh)"

# Alias
alias ls="ls -p -G"
alias la="ls -A"
alias ll="ls -l"
alias lla="ll -A"
alias g=git
alias lv=lvim
alias v=nvim
alias c='cursor'
alias ws='windsurf'

alias python=/usr/local/bin/python3
alias lg='lazygit'

# bindkey -s ^f "tmux-sessionizer\n"

# source ~/.config/zsh/omer.zsh-theme
source ~/.config/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.config/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# source ~/.config/zsh/zsh-git-prompt/zshrc.sh
eval "$(starship init zsh)"

# # Blur {{{
# if [[ $(ps --no-header -p $PPID -o comm) =~ '^yakuake|kitty$' ]]; then
#         for wid in $(xdotool search --pid $PPID); do
#             xprop -f _KDE_NET_WM_BLUR_BEHIND_REGION 32c -set _KDE_NET_WM_BLUR_BEHIND_REGION 0 -id $wid; done
# fi
# }}}
