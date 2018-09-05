export PYENV_ROOT="$HOME/.pyenv"
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

# If not running interactively, don't do anything

[ -z "$PS1" ] && return
# Resolve DOTFILES_DIR (assuming ~/.dotfiles on distros without readlink and/or $BASH_SOURCE/$0)

READLINK=$(which greadlink || which readlink)
CURRENT_SCRIPT=$BASH_SOURCE

if [[ -n $CURRENT_SCRIPT && -x "$READLINK" ]]; then
  SCRIPT_PATH=$($READLINK -f "$CURRENT_SCRIPT")
  DOTFILES_DIR=$(dirname "$(dirname "$SCRIPT_PATH")")
elif [ -d "$HOME/.dotfiles" ]; then
  DOTFILES_DIR="$HOME/.dotfiles"
else
  echo "Unable to find dotfiles, exiting."
  return
fi

# Make utilities available

PATH="$DOTFILES_DIR/bin:$PATH"

# Read cache

DOTFILES_CACHE="$DOTFILES_DIR/.cache.sh"
[ -f "$DOTFILES_CACHE" ] && . "$DOTFILES_CACHE"

# Finally we can source the dotfiles (order matters)

for file in env aliases prompt exports; do
  DOTFILE="$DOTFILES_DIR"/system/."$file"
  [ -f "$DOTFILE" ] && . "$DOTFILE"
done

# Set LSCOLORS

eval "$(dircolors "$DOTFILES_DIR"/system/.dir_colors)"

# Hook for extra/custom stuff

DOTFILES_EXTRA_DIR="$HOME/.extra"

if [ -d "$DOTFILES_EXTRA_DIR" ]; then
    for EXTRAFILE in "$DOTFILES_EXTRA_DIR"/runcom/*.sh; do
        [ -f "$EXTRAFILE" ] && . "$EXTRAFILE"
    done
fi


# Clean up

unset READLINK CURRENT_SCRIPT SCRIPT_PATH DOTFILE EXTRAFILE

# Export

export DOTFILES_DIR

if [ -f ~/.bashrc ]
then
source ~/.bashrc
fi
