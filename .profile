#Set our git repository location
dotfiles="${HOME}/dotfiles"

#Set a umask
umask 002

#Determine OS information variables to use elsewhere
os_name=`uname -s`
arch=`uname -m`

#Turn off stop/resume on interactive shells to avoid odd behavior with tmux
[[ $- == *i* ]] && stty -ixon

#Setup our shell source files
##This is the sources file to load before anything else to setup and dependencies other source files may need
pre_sources="${dotfiles}/vars"

##Sources shared by both zsh and bash
common_sources="${dotfiles}/functions \
                ${dotfiles}/aliases \
                ${dotfiles}/.gpg_config \
                ${HOME}/local \
                ${HOME}/.demandbase \
                ${HOME}/.rvm/scripts/rvm"

##bash specific sources
if [ "$BASH" ]; then
    shell_sources="${dotfiles}/bash_colors \
                  /etc/bash_completion \
                  /usr/local/etc/bash_completion \
                  /etc/bash_completion.d/git \
                  ${dotfiles}/google-cloud-sdk/completion.bash.inc \
                  ${dotfiles}/google-cloud-sdk/path.bash.inc \
                  ${dotfiles}/bashrc"
fi

##zsh specific sources
if [ "${ZSH_VERSION}" ]; then
    #Set zsh similar to bash to use ${sources} in a for loop below
    set -o shwordsplit
    HOSTNAME=`hostname`
    shell_sources="${dotfiles}/zshrc \
                   ${dotfiles}/google-cloud-sdk/completion.zsh.inc \
                   ${dotfiles}/google-cloud-sdk/path.zsh.inc"
fi

#Build a list of sources with common_sources as overrides
sources="${pre_sources} ${shell_sources} ${common_sources}"

#Build a file list and load any that exist
for sourcefile in ${sources}; do
    if [ -f ${sourcefile} ]; then
        source "${sourcefile}"
    fi
done

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
