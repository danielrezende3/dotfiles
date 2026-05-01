# This is to set to allow 256 colors, which is useful for themes and plugins that rely on color output.
export TERM=xterm-256color

# Set the location of the Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# add bin to path
export PATH=~/bin:$PATH

ZSH_THEME="zhann"

# Plugins to load
plugins=(git zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh
