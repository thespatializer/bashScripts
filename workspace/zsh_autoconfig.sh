#!/bin/bash -e

# Set Bash color
ECHO_PREFIX_INFO="\033[1;32;40mINFO...\033[0;0m"
ECHO_PREFIX_ERROR="\033[1;31;40mError...\033[0;0m"

# Try command  for test command result.
function try_command {
    "$@"
    status=$?
    if [ $status -ne 0 ]; then
        echo -e $ECHO_PREFIX_ERROR "ERROR with \"$@\", Return status $status."
        exit $status
    fi
    return $status
}

# Detect system arch.
ULONG_MASK=`getconf ULONG_MAX`
if [ $ULONG_MASK == 18446744073709551615 ]; then
    SYSARCH=64
else
    echo -e $ECHO_PREFIX_ERROR "This package does not support 32-bit system.\n"
    exit 1
fi


if [ `cat /etc/os-release | grep -E "CentOS" | wc -l` -ne 0 ]; then
    try_command sudo yum -y install redhat-lsb-core
elif [ `cat /etc/os-release | grep -E "ID_LIKE=debian" | wc -l` -ne 0 ] \
        || [ `cat /etc/os-release | grep -E "ID=debian" | wc -l` -ne 0 ]; then
    try_command sudo apt-get update
    try_command sudo apt-get install -y lsb-release
elif [ `cat /etc/os-release | grep -E "ID_LIKE=arch" | wc -l` -ne 0 ]; then
    try_command sudo pacman -S --noconfirm lsb-release
else
    echo -e $ECHO_PREFIX_ERROR "This OS is not supported.\n"
    exit 1
fi

try_command lsb_release -si > /dev/null

LINUX_DISTRO=`lsb_release -si`

if [ "$LINUX_DISTRO" == "Ubuntu" ] || [ "$LINUX_DISTRO" == "Debian" ]; then
    try_command sudo apt-get install -y zsh wget curl git
elif [ "$LINUX_DISTRO" == "CentOS" ]; then
    try_command sudo yum install -y zsh wget curl git
elif [ "$LINUX_DISTRO" == "ManjaroLinux" ]; then
    try_command sudo pacman -S --noconfirm zsh wget curl git
else
    echo -e $ECHO_PREFIX_INFO "The installation will be cancelled."
    echo -e $ECHO_PREFIX_INFO "The script only supports Ubuntu, CentOS or Manjaro.\n"
    exit 1
fi

try_command sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
try_command curl -o ~/.oh-my-zsh/themes/honukai.zsh-theme https://raw.githubusercontent.com/oskarkrawczyk/honukai-iterm-zsh/master/honukai.zsh-theme
try_command sed -i "s/ZSH_THEME=\"robbyrussell\"/ZSH_THEME=\"honukai\"/g" ~/.zshrc
try_command echo "
##
# Zsh Autoconfig
##

# VCS helpers
autoload -U run-help
autoload run-help-git
autoload run-help-svn
autoload run-help-svk
alias help=run-help" >> ~/.zshrc

try_command git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/plugins/zsh-syntax-highlighting
try_command echo "
# Syntax Highlighting
source ~/.oh-my-zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Persistent rehash: This allows compinit to automatically find new executables in the $PATH.
zstyle ':completion:*' rehash true" >> ~/.zshrc

try_command git clone https://github.com/zsh-users/zsh-completions ~/.oh-my-zsh/custom/plugins/zsh-completions
try_command echo "
# Zsh Completions
plugins+=(zsh-completions)
autoload -U compinit && compinit" >> ~/.zshrc

echo -e $ECHO_PREFIX_INFO "Installation completed."

try_command chsh -s /usr/bin/zsh $USER