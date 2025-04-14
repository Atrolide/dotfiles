#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='lsd -a --color=auto'
alias grep='grep --color=auto'
alias hx='helix'
alias ..='cd ..'
PS1='[\u@\h \W]\$ '
