#! /bin/bash

# Shortcuts

alias reload="source ~/.bash_profile"
alias _="sudo"

# Default options

alias psgrep="psgrep -i"

# Global aliases

# List declared aliases, functions, paths

alias aliases="alias | sed 's/=.*//'"
alias functions="declare -f | grep '^[a-z].* ()' | sed 's/{$//'"
alias paths='echo -e ${PATH//:/\\n}'

# Directory listing/traversal

LS_COLORS="--color -G"
LS_TIMESTYLEISO="--time-style=long-iso"
LS_GROUPDIRSFIRST="--group-directories-first"

alias ls="ls $LS_COLORS $LS_TIMESTYLEISO $LS_GROUPDIRSFIRST"
alias lpm="stat -c '%a %n' *"

unset LS_COLORS LS_TIMESTYLEISO LS_GROUPDIRSFIRST

alias cd="cd -P"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias -- -="cd -"                  # Go to previous dir with -
alias cd.='cd $(readlink -f .)'    # Go to real dir (i.e. if current dir is linked)

alias tree="tree -A"
alias treed="tree -d"
alias tree1="tree -d -L 1"
alias tree2="tree -d -L 2"

# Network

alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias ipl="ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1'"

# Request using GET, POST, etc. method

for METHOD in GET HEAD POST PUT DELETE TRACE OPTIONS; do
  alias "$METHOD"="lwp-request -m '$METHOD'"
done
unset METHOD

# Miscellaneous

alias hosts="sudo $EDITOR /etc/hosts"
alias his="history"
alias quit="exit"
alias week="date +%V"
alias speedtest="wget -O /dev/null http://speed.transip.nl/100mb.bin"

###################
#
# Notes
#
###################

function lsnote {
    local i=0
    while read line ; do
        i=$(($i+1))
        echo "$i:  $line"
    done <$HOME/.local/notes
}
function mknote {
    echo $@ >> $HOME/.local/notes
}
function rmnote {
    sed -i "${1}d" $HOME/.local/notes
}

###################
#
# Clipboard 
#
###################

function xcopy {
    xclip -selection clipboard "$@"
}
function xpaste {
    xclip -selection clipboard -o "$@"
}


###################
#
# .configure 
#
###################
function configure_home_bld {
    echo "./configure --prefix=$HOME/usr --exec-prefix=$HOME/usr $@"
    ./configure --prefix=$HOME/usr --exec-prefix=$HOME/usr $@
}

###################
#
# csh-to-bash stuff
#
###################
#Yeah, these are beasts.
_assign_match="(('[^']+')|(\"[^\"]+\")|(\`[^\`]+\`)|([^ \t]+))"
function __csh_alias_to_alias { 
	args="-i"
	if $2; then { args="-i\".bck\"" ; } ; fi
	sed -re "s/^[ \t]*alias[ \t]+([^ \t]+)[ ^t]+${_assign_match}[ ^t]*$/alias \1=\2/" "$1" $args
}
#bash functions handle better than aliases when it comes to exporting and script availability
#And are encouraged to be used over aliases
function __csh_alias_to_func { 
	args="-i"
	if $2; then { args="-i\".bck\"" ; } ; fi
	sed -re "s/^[ \t]*alias[ \t]+([^ \t]+)[ ^t]+${_assign_match}[ ^t]*$/function \1 { eval \2 \"\$@\" ; }\nexport -f \1/" "$1" $args
}
function csh_alias_to_bash {
	if [ ! -e "$1" ] ; then
		echo "Need file"
		return 1
	fi
	
	bckup=true
	local ret=`grep -e "[ \t]*set[ \t]" "$1"`
	if [ ! -z "$ret" ] ; then
		echo "set is used in this file"
		#Replace set with a setloc, a custom function that acts similarly to set in csh
		sed -re "s/set[ \t]+([^ \t=]+)[ \t]*=[ \t]*$_assign_match/setloc \1 \2/" "$1" -i".bck"
		bckup=false
	fi

	#__csh_alias_to_alias $1 $bckup

	__csh_alias_to_func $1 $bckup
}
# setloc name value
# Sets `name` as a local environment variable to `value`
# TODO: Allow for name = value and name=value to replicate
# csh behavior?
function setloc {
	if [[ "$#" != 2 ]] ; then
		echo "Need 2 arguments"
		return 1
	fi

	printf -v "$1" "$2"
}

# setenv name value
# Sets `name` as a exported environment variable to `value`
function setenv {
	if [[ "$#" != 2 ]] ; then
	   echo "Need 2 arguments"
	   return 1
	fi
	printf -v "$1" "$2"
	export "$1"
}
export -f setloc setenv

function invalid_name {
    echo "$1" | grep -xE "[a-zA-Z_][a-zA-Z0-9_]*" > /dev/null
    return $(( ! $? ))
}

local private_aliases="~/.bash_aliases_p" 

if [ -f ${private_aliases} ] 
then
    . ${private_aliases}
fi


