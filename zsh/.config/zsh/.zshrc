# Lines configured by zsh-newuser-install
HISTFILE=~/.config/zsh/histfile
HISTSIZE=9999999
SAVEHIST=9999999

setopt nomatch notify
setopt RM_STAR_WAIT
setopt completealiases
setopt HIST_IGNORE_DUPS
setopt SHARE_HISTORY
setopt INTERACTIVE_COMMENTS


unsetopt autocd beep extendedglob

autoload -U colors
colors

bindkey -v

bindkey "^R" history-incremental-search-backward
bindkey "^S" history-incremental-search-forward

# The following lines were added by compinstall

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
# End of lines added by compinstall

fpath=(~/.config/zsh/completions $fpath)

export PATH=$PATH:~/scripts
export PATH=$PATH:~/scripts/bin
export PATH=$PATH:/usr/bin/core_perl
export PATH=$PATH:~/.gem/ruby/2.2.0/bin
export PATH=$PATH:~/.local/bin


. ~/.config/zsh/git-prompt.sh

setopt PROMPT_SUBST

export GIT_PS1_SHOWDIRTYSTATE="yes"
export GIT_PS1_SHOWSTASHSTATE="yes"
export GIT_PS1_SHOWUNTRACKEDFILES="yes"
export GIT_PS1_SHOWCOLORHINTS="yes"

export PROMPT='
%6F%n%7F@%1F%m%7F %{%F{yellow}%}%~%f %(?..%{%F{red}%}[%?]%f) $(__git_ps1 "[%s]")
%{%F{blue}%}#%f '

export XDG_CONFIG_HOME="$HOME/.config"

export VIMINIT='let $MYVIMRC="$XDG_CONFIG_HOME/vim/vimrc" | source $MYVIMRC'
export VIMDOTDIR="$XDG_CONFIG_HOME/vim"
export LESSHISTFILE="/dev/null"
export REPORTTIME=5
export MAIL="~/mail/INBOX"
export EDITOR=vim

man() {
    env LESS_TERMCAP_mb=$'\E[01;31m' \
    LESS_TERMCAP_md=$'\E[01;38;5;74m' \
    LESS_TERMCAP_me=$'\E[0m' \
    LESS_TERMCAP_se=$'\E[0m' \
    LESS_TERMCAP_so=$'\E[38;5;246m' \
    LESS_TERMCAP_ue=$'\E[0m' \
    LESS_TERMCAP_us=$'\E[04;38;5;146m' \
    man "$@" 2>/dev/null || $1 --help | less
}

chpwd() {
    print -Pn "\e]0;`pwd`\a";

    if ( [[ $silentcd != 1 ]] ) {
        ls --group-directories-first --color=auto;
    }

    silentcd=0
}

fbatch() {
    find -type f -name "*.$1" -print0 | while read -d $'\0' a; do
    < /dev/null ffmpeg -v 8 -i "$a" -ab 320k -qscale:a 0 "${a[@]/%$1/$2}"
    echo $a
    done
}

vorbedit() {
    vorbiscomment -l $1 | vipe | vorbiscomment -w $1
}

shot() {
    scrot /tmp/screenshot.png
    i3-msg workspace "edit"
    gimp /tmp/screenshot.png >/dev/null
    i3-msg workspace back_and_forth
    teknik /tmp/screenshot.png
}

adb() {
    OLDHOME="$HOME"
    HOME="$OLDHOME/.config/android"
    /bin/adb $*
    HOME="$OLDHOME"
}

alias scratch='mkdir -p ~/downloads/scratch; cd $(mktemp -d -p ~/downloads/scratch)'
alias 0="false"
alias 1="true"
alias headers="curl --dump-header /dev/stdout --output /dev/null --silent"
alias pubip="dig +short myip.opendns.com @resolver1.opendns.com"
alias restartpa="pulseaudio -k ; pulseaudio --start"

alias timetable="cat ~/scripts/data/timetable"
# Not a UUOC, just doing `< file` will run it through a pager, which I don't
# want.

alias pdb="python -m pdb"

alias ag="ag -A 3 -B 3"
alias df="dfc -t -devtmpfs,tmpfs,autofs -T -d -q type -W -w 2>/dev/null"
alias du="du -ch"
alias grep="grep -E --color=auto"
alias ls="ls --group-directories-first --color=auto"
alias msmtp="msmtp -C ~/.config/msmtp/config"
alias mutt="mutt -F ~/.config/mutt/muttrc"
alias ncmpcpp="ncmpcpp --config ~/.config/ncmpcpp/config --bindings ~/.config/ncmpcpp/bindings"
alias startx="startx ~/.config/X/xinitrc"
alias tmux="tmux -f ~/.config/tmux/tmux.conf"
alias weechat="weechat -d $XDG_CONFIG_HOME/weechat"
alias watch="watch -c"
alias pacman="pacaur"
alias gs="git status"
alias cget="curl -C - -L -O --retry 10"

zmodload zsh/terminfo

source /usr/share/zsh/plugins/zsh-syntax-highlighting\
/zsh-syntax-highlighting.zsh

ZSH_HIGHLIGHT_HIGHLIGHTERS=(main pattern brackets root)
ZSH_HIGHLIGHT_PATTERNS+=("sudo*" "bg=red")

source /usr/share/doc/pkgfile/command-not-found.zsh

. =(dircolors ~/.config/zsh/dircolors-database)
. ~/.config/zsh/.zshenv
. ~/.config/zsh/agent.sh
. ~/.config/zsh/plugins/safe-paste.plugin.zsh
. ~/.config/zsh/private.sh

print -Pn "\e]0;`pwd`\a"
