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
setopt complete_aliases
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
export PATH=$PATH:~/.gem/ruby/2.7.0/bin
export PATH=$PATH:~/.local/bin
export PATH=$PATH:~/.cargo/bin
# }}}

# prompt {{{

. ~/.config/zsh/plugins/git-prompt.zsh/git-prompt.zsh

ZSH_THEME_GIT_PROMPT_PREFIX=" ["
ZSH_THEME_GIT_PROMPT_SUFFIX="] "
ZSH_THEME_GIT_PROMPT_SEPARATOR="|"
ZSH_THEME_GIT_PROMPT_DETACHED="%{$fg_bold[cyan]%}:"
ZSH_THEME_GIT_PROMPT_BRANCH="%{$fg_bold[magenta]%}"
ZSH_THEME_GIT_PROMPT_BEHIND="↓"
ZSH_THEME_GIT_PROMPT_AHEAD="↑"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[red]%}✖"
ZSH_THEME_GIT_PROMPT_STAGED="%{$fg[green]%}●"
ZSH_THEME_GIT_PROMPT_UNSTAGED="%{$fg[red]%}✚"
ZSH_THEME_GIT_PROMPT_UNTRACKED="…"
ZSH_THEME_GIT_PROMPT_STASHED="%{$fg[blue]%}⚑"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[green]%}✔"

ZSH_GIT_PROMPT_SHOW_STASH=1

export PROMPT='
%6F%n%7F@%1F%m%7F %{%F{yellow}%}%~%f$(gitprompt)%(?..%{%F{red}%}[%?]%f)
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
export PASSWORD_STORE_DIR="$HOME/media/syncthing/sync/password-store"
export DOTNET_CLI_TELEMETRY_OPTOUT=1
export GEM_HOME="$HOME/.gems"
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

if (defined sudo) {
    # Expands aliases inside sudo
    alias sudo="sudo "
}

if (defined youtube-dl) {
    alias youtube-dl="noglob youtube-dl $@"
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

scratch() {
    cd "$(mktemp -d)"
}

defined curl && alias headers="curl --dump-header /dev/stdout --output /dev/null --silent"

if (defined git) {
    alias gs="git status"
}

defined curl && alias cget="curl -C - -L -O --retry 10"

defined todo.sh && alias t="todo.sh"

if (defined todo) {
    function todo() {
        command todo -ct $@
    }
}

if (defined cargo) {
    alias cr="cargo run"
    alias crr="cargo run --release"
}

if (defined systemctl) {
    function userctl() {
        systemctl --user $@
    }
}

function bandcamp_rip() {
  scratch
  elinks --dump --no-numbering https://$1.bandcamp.com/ | 
  grep -e '.com/album' -e '.com/track' | 
  sed 's/.*https/https/g' |
  uniq > links.txt
  youtube-dl -o $1" - %(playlist)s/%(playlist_index)s. %(title)s.%(ext)s" -a links.txt
  rm links.txt
}

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
. ~/.config/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
. ~/.config/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

ZSH_AUTOSUGGEST_STRATEGY=(completion)
ZSH_AUTOSUGGEST_USE_ASYNC="trans rights" # i was told it could be set to anything

if (defined termux-info) {
    # for termux ssh agent
    export GIT_SSH_COMMAND="ssha"
    export USER="jess"
}

defined keychain && eval $(keychain --eval --quiet --agents ssh)

return 0
