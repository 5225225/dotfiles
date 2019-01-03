# vim:foldmethod=marker

# history {{{
HISTFILE=~/.config/zsh/histfile
HISTSIZE=9999999
SAVEHIST=9999999

setopt HIST_IGNORE_DUPS
setopt hist_verify
setopt SHARE_HISTORY
# }}}

# misc options {{{
setopt nomatch
setopt notify
setopt RM_STAR_WAIT
setopt completealiases
setopt INTERACTIVE_COMMENTS

unsetopt autocd
unsetopt beep
unsetopt extendedglob

bindkey -v

bindkey "^R" history-incremental-search-backward
bindkey "^S" history-incremental-search-forward

autoload -U colors
colors
# }}}

# {{{ completion

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _ignored _match _correct _approximate _prefix
zstyle ':completion:*' completions 1
zstyle ':completion:*' expand prefix suffix
zstyle ':completion:*' file-sort name
zstyle ':completion:*' format '----------Completing %F{cyan}%d%f----------'
zstyle ':completion:*' glob 1
zstyle ':completion:*' group-name ''
zstyle ':completion:*' insert-unambiguous true
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-prompt '%SAt %p: Hit TAB for more, or the character to insert%s'
zstyle ':completion:*' list-suffixes true
zstyle ':completion:*' matcher-list '' 'm:{[:lower:]}={[:upper:]} m:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'l:|=* r:|=*'
zstyle ':completion:*' max-errors 1
zstyle ':completion:*' menu select=long
zstyle ':completion:*' original false
zstyle ':completion:*' preserve-prefix '//[^/]##/'
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*' substitute 1
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true
zstyle :compinstall filename '~/.config/zsh/.zshrc'

autoload -Uz compinit
compinit
# }}}

# Adding to $PATH and fpath {{{
fpath=(~/.config/zsh/completions $fpath)

export PATH=$PATH:~/scripts
export PATH=$PATH:~/scripts/bin
export PATH=$PATH:/usr/bin/core_perl
export PATH=$PATH:~/.gem/ruby/2.2.0/bin
export PATH=$PATH:~/.local/bin
export PATH=$PATH:~/.cargo/bin
# }}}

# prompt {{{

. ~/.config/zsh/git-prompt.sh
setopt PROMPT_SUBST

export GIT_PS1_SHOWDIRTYSTATE="yes"
export GIT_PS1_SHOWSTASHSTATE="yes"
export GIT_PS1_SHOWUNTRACKEDFILES="yes"
export GIT_PS1_SHOWCOLORHINTS="yes"

export PROMPT='
%6F%n%7F@%1F%m%7F %{%F{yellow}%}%~%f %(?..%{%F{red}%}[%?]%f) $(__git_ps1 "[%s]")
%{%F{blue}%}#%f '

# }}}

# envars and xdg settings {{{
export VIMINIT='let $MYVIMRC="$XDG_CONFIG_HOME/vim/vimrc" | source $MYVIMRC'
export VIMDOTDIR="$XDG_CONFIG_HOME/vim"
export LESSHISTFILE="/dev/null"
export REPORTTIME=5
export MAIL="~/mail/INBOX"
export EDITOR=vim
export LEDGER_FILE="$HOME/sync/ledger/hledger.txt"

# less colours {{{
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;38;5;74m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[38;5;246m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[04;38;5;146m'
# }}}
# }}}

# utility functions {{{
defined() {
    which $1 2>&1 >/dev/null
}

try_source() {
    [ -f "$1" ] && source "$1"
}

# }}}

# hooks {{{
chpwd() {
    ls
}
# }}}

# command enhancements {{{
# Translations to better versions, as well as setting default options.

if (defined exa) {
    ls() {
        exa --group-directories-first --git --extended $@
    }
} else {
    ls() {
        command ls --group-directories-first --color=auto $@
    }
}

df() {
    if (defined dfc) {
        dfc -t -devtmpfs,tmpfs,autofs -T -d -q type -W -w 2>/dev/null $@
    } else {
        command df -h $@
    }
}

if (defined du) {
    alias "du"="du -ch"
}

if (defined grep) {
    alias grep="grep --color=auto"
}

if (defined msmtp) {
    alias msmtp="msmtp -C ~/.config/msmtp/config"
}

if (defined yay) {
    alias pacman="yay"
}

if (defined ncmpcpp) {
    alias ncmpcpp="ncmpcpp --config ~/.config/ncmpcpp/config --bindings ~/.config/ncmpcpp/bindings"
}

defined mutt && alias mutt="mutt -F ~/.config/mutt/muttrc"
defined startx && alias startx="startx ~/.config/X/xinitrc"
defined tmux && alias tmux="tmux -f ~/.config/tmux/tmux.conf"
defined weechat && alias weechat="weechat -d $XDG_CONFIG_HOME/weechat"
defined abook && alias abook="abook -C ~/.config/abook/abookrc --datafile ~/.config/abook/addressbook"

# }}}

# utility functions {{{
# Functions that may depend on shell commands, but are not shadowing one

priv() {
    RPROMPT="[priv] $RPROMPT"
    export HISTFILE="/dev/null"
}

defined curl && alias headers="curl --dump-header /dev/stdout --output /dev/null --silent"

if (defined git) {
    alias gs="git status"
}

defined curl && alias cget="curl -C - -L -O --retry 10"

defined todo.sh && alias t="todo.sh"

# }}}

zmodload zsh/terminfo
export TERM=rxvt-unicode-256color

# syntax highlighting {{{
try_source /usr/share/zsh/plugins/zsh-syntax-highlighting\
/zsh-syntax-highlighting.zsh

ZSH_HIGHLIGHT_HIGHLIGHTERS=(main pattern brackets root)
ZSH_HIGHLIGHT_PATTERNS+=("sudo" "bg=red")

# }}}

try_source /usr/share/doc/pkgfile/command-not-found.zsh

. ~/.config/zsh/plugins/safe-paste.plugin.zsh
. ~/.config/zsh/.zshenv

defined keychain && eval $(keychain --eval --quiet --agents ssh,gpg id_ed25519 id_rsa nas_id_rsa 8106B50C716333773F02BA1CE29454EE184E7DC8)

return 0
