#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='lsd -1 --blocks name,permission,git,size'
alias la='ls -A'
alias tree='lsd --tree'
alias grep='grep --color=auto'
alias hx='helix'
alias ..='cd ..'
PS1='[\u@\h \W]\$ '
