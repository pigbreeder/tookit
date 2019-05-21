export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced
export TIME_STYLE='+%Y-%m-%d %H:%M:%S' 
export GREP_OPTIONS="-n --color"
## history settings.
export HISTFILE=~/.bash_history
export HISTFILESIZE=10000
export HISTSIZE=10000
export HISTCONTROL=erasedups
alias tmux='tmux -2' # Force tmux to assume the terminal supports 256 colours
alias duf='du -h --max-depth=1'
alias cdd='cd /mfs_gpu/exec/xsy'
xsy=/mfs_gpu/exec/xsy
export xsy

alias path='echo -e ${PATH//:/\\n}'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias ll='ls -Flh --group-directories-first --color=auto'
alias l='ls -Flh --group-directories-first --color=auto'
alias la='ls -FlhA --group-directories-first --color=auto'
alias mkdir="mkdir -p"
alias tmux="TERM=screen-256color-bce tmux"
alias j='jobs -l'
alias vi=vim

alias lx='ls -lhBX'        #sort by extension
alias lz='ls -lhrS'        #sort by size
alias lt='ls -lhrt'        #sort by date    最常用到，ls -rt，按修改时间查看目录下文件

# process 
alias ports='netstat -tulanp'
alias cat='LC_ALL=C cat -n'
alias openports='netstat -nape --inet'
alias psg='ps aux|grep'

# hadoop

alias hdu="hadoop fs -du -h"
alias hdl="hadoop fs -ls"
alias hdc="hadoop fs -cat"

#combine mkdir alias's
alias osu="open -a Sublime\ Text\ 2"
alias prof="subl ~/.bash_profile"
alias reprof=". ~/.bash_profile"

# Navigational alias's

# Shortcut commands
alias py="python"
alias osu="open -a Sublime\ Text\ 2"


# Github commands
alias gb="git branch"
alias gs="git status"
alias ga="git add"
alias gc="git commit"
alias gl="git log"
alias glo="git log --pretty=oneline"
alias glu="git log --pretty=format:'%h %ad | %s%d [%an]' --graph --date=short"
alias gh="git checkout"
alias gt="git tag"
alias grs="git reset"
alias grv="git revert"
alias gm="git merge"
alias gpom="git push origin master"
alias gpum="git pull origin master"
alias gd="git diff"
alias gpo="git push origin"
alias gob="git checkout -b"

# Docker
alias bd="boot2docker"
alias bds="boot2docker start"
alias dk="docker"
alias dkr="docker run"

docker-ip() {
boot2docker ip 2> /dev/null
}

# combine mkdir and cd
mkcd () {
	mkdir "$1"
	cd "$1"
}


# Define Colors {{{
TXTBLK="\[\033[0;30m\]" # Black - Regular
TXTRED="\[\033[0;31m\]" # Red
TXTGRN="\[\033[0;32m\]" # Green
TXTYLW="\[\033[0;33m\]" # Yellow
TXTBLU="\[\033[0;34m\]" # Blue
TXTPUR="\[\033[0;35m\]" # Purple
TXTCYN="\[\033[0;36m\]" # Cyan
TXTWHT="\[\033[0;37m\]" # White
BLDBLK="\[\033[1;30m\]" # Black - Bold
BLDRED="\[\033[1;31m\]" # Red
BLDGRN="\[\033[1;32m\]" # Green
BLDYLW="\[\033[1;33m\]" # Yellow
BLDBLU="\[\033[1;34m\]" # Blue
BLDPUR="\[\033[1;35m\]" # Purple
BLDCYN="\[\033[1;36m\]" # Cyan
BLDWHT="\[\033[1;37m\]" # White
UNDBLK="\[\033[4;30m\]" # Black - Underline
UNDRED="\[\033[4;31m\]" # Red
UNDGRN="\[\033[4;32m\]" # Green
UNDYLW="\[\033[4;33m\]" # Yellow
UNDBLU="\[\033[4;34m\]" # Blue
UNDPUR="\[\033[4;35m\]" # Purple
UNDCYN="\[\033[4;36m\]" # Cyan
UNDWHT="\[\033[4;37m\]" # White
BAKBLK="\[\033[40m\]"   # Black - Background
BAKRED="\[\033[41m\]"   # Red
BAKGRN="\[\033[42m\]"   # Green
BAKYLW="\[\033[43m\]"   # Yellow
BAKBLU="\[\033[44m\]"   # Blue
BAKPUR="\[\033[45m\]"   # Purple
BAKCYN="\[\033[46m\]"   # Cyan
BAKWHT="\[\033[47m\]"   # White
TXTRST="\[\033[0m\]"    # Text Reset
# }}}
#######################
# Functions           #
#######################
# extract compress cl sysinfo dirsize swap
# Easy extract
extract ()
{
  if [ -f $1 ] ; then
      case $1 in
          *.tar.bz2)   tar xvjf $1    ;;
          *.tar.gz)    tar xvzf $1    ;;
          *.bz2)       bunzip2 $1     ;;
          *.rar)       rar x $1       ;;
          *.gz)        gunzip $1      ;;
          *.tar)       tar xvf $1     ;;
          *.tbz2)      tar xvjf $1    ;;
          *.tgz)       tar xvzf $1    ;;
          *.zip)       unzip $1       ;;
          *.Z)         uncompress $1  ;;
          *.7z)        7z x $1        ;;
          *)           echo "don't know how to extract '$1'..." ;;
      esac
  else
      echo "'$1' is not a valid file!"
  fi
}

# easy compress - archive wrapper
compress ()
{
    if [ -n "$1" ] ; then
        FILE=$1
        case $FILE in
        *.tar) shift && tar cf $FILE $* ;;
        *.tar.bz2) shift && tar cjf $FILE $* ;;
        *.tar.gz) shift && tar czf $FILE $* ;;
        *.tgz) shift && tar czf $FILE $* ;;
        *.zip) shift && zip $FILE $* ;;
        *.rar) shift && rar $FILE $* ;;
        esac
    else
        echo "usage: compress <foo.tar.gz> ./foo ./bar"
    fi
}

# get current host related info
function sysinfo()
{
    echo -e "\nYou are logged on ${RED}$HOST"
    echo -e "\nAdditionnal information:$NC " ; uname -a
    echo -e "\n${RED}Users logged on:$NC " ; w -h
    echo -e "\n${RED}Current date :$NC " ; date
    echo -e "\n${RED}Machine stats :$NC " ; uptime
    echo -e "\n${RED}Memory stats :$NC " ; free
    echo -e "\n${RED}Local IP Address :$NC" ; myip
}

# Get IP (call with myip)
function myip
{
    myip=`elinks -dump http://checkip.dyndns.org:8245/`
    echo "${myip}"
}

encrypt () { gpg -ac --no-options "$1"; }
decrypt () { gpg --no-options "$1"; }

# finds directory sizes and lists them for the current directory
dirsize ()
{
    du -shx * .[a-zA-Z0-9_]* . 2> /dev/null | \
    egrep '^ *[0-9.]*[MG]' | sort -n > /tmp/list
    egrep '^ *[0-9.]*M' /tmp/list
    egrep '^ *[0-9.]*G' /tmp/list
    /bin/rm -rf /tmp/list
}

# ls when cd, it's useful
function cl ()
{
    if [ -n "$1" ]; then
        builtin cd "$@"&& ls -la --group-directories-first --time-style=+"%Y-%d-%m %H:%M:%S" --color=auto -F && pwd
    else
        builtin cd ~&& ls
    fi
}

# swap() -- switch 2 filenames around
function swap()
{
    local TMPFILE=tmp.$$
    mv "$1" $TMPFILE
    mv "$2" "$1"
    mv $TMPFILE "$2"
}

# repeat() -- repeat a given command N times
function repeat()
{
    local i max
    max=$1; shift;
    for ((i=1; i <= max ; i++)); do
        eval "$@";
    done
}

# Find a file with pattern $1 in name and Execute $2 on it:
function fe()
{ wcfind . -type f -iname '*'${1:-}'*' -exec ${2:-ls} {} \;  ; }


# RSS/RES 是常驻内存集（Resident Set Size），表示该进程分配的内存大小。
# VSZ/VIRT 表示进程分配的虚拟内存
# SHR 进程占用的共享内存值
# 移动
# C-b 左移光标
# C-f 右移光标
# A-b 左移单词
# A-f 右移单词
# C-a 行首
# C-e 行尾
# 删除
# C-h 左删字符
# C-d 右删字符
# C-w 左删单词
# A-d 右删单词
# C-u 左删一行
# C-k 右删一行
# 其他
# C-l 清屏
# C-r 搜索
# C-p 上条命令
# C-n 下条命令

# C-y 撤销
