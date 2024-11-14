#! /bin/bash

echo "Setting up your new machine..."

# Install MDM-bypass
curl https://raw.githubusercontent.com/eudy97/MDM-bypass/main/MDM-bypass.sh -o MDM-bypass.sh
chmod +x MDM-bypass.sh

### Setting up zsh ###

# Check is zsh is installed
if ! command -v zsh &> /dev/null
then
    echo "Zsh could not be found, installing..."
    brew install zsh
fi

# Switch to zsh
chsh -s $(which zsh)

# Install Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install Powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# Configure Oh My Zsh to use powerlevel10k
sed -i '' 's/^ZSH_THEME=.*/ZSH_THEME="powerlevel10k\/powerlevel10k"/' ~/.zshrc

# Start new terminal session
exec zsh

# If that didn't work, try this:
# exec zsh -l
# Or open a new terminal window and run:
# p10k configure

# Install zsh-autosuggestions & zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting

# Start new terminal session
exec zsh

# If that didn't work, try this:
# exec zsh -l
# Or open a new terminal window and run:
# p10k configure

### Installing tools ###

# Install Homebrew
echo "Installing Homebrew & tools..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install tools
brew install rbenv pyenv gh awscli direnv zoxide fzf atomicjar/tap/testcontainers-desktop maccy

# Install raycast
brew install --cask raycast
# TODO: figure out how to install raycast apps from terminal

# Install 1Password
brew install --cask 1password

# Install Arc Browser
brew install --cask arc

# Install docker desktop
brew install --cask docker

# Install Rectangle
brew install --cask rectangle

# Install cursor.ai
brew install --cask cursor
# TODO: figure out how to export cursor settings and save here
# TODO: figure out how to install cursor extensions from terminal

### Configure zsh ###

# Add plugins to zshrc using sed
sed -i '' 's/^plugins=.*/plugins=(git zsh-autosuggestions zsh-syntax-highlighting aliases aws docker docker-compose)/' ~/.zshrc

# Append source zprofile with if statement to zshrc file
echo "if [ -f ~/.zprofile ];then
  . ~/.zprofile
fi" >> ~/.zshrc

# Append auto completion to zshrc file
echo "# Auto Completion
autoload bashcompinit && bashcompinit
autoload -Uz compinit && compinit
complete -C \"$HOMEBREW_PREFIX/bin/aws_completer\" aws
complete -o nospace -C /opt/homebrew/bin/terraform terraform
# Don't use kubectl right now
# compdef __start_kubectl k" >> ~/.zshrc

# Append lesspipe to zshrc file
echo "# Less Syntax Highlights
LESSPIPE=`which src-hilite-lesspipe.sh`
export LESSOPEN="| ${LESSPIPE} %s"
export LESS=' -R -F '" >> ~/.zshrc

### Configure zprofile ###

echo "# Homebrew
eval \"$(/opt/homebrew/bin/brew shellenv)\"

# Rbenv
export PATH=\"$HOME/.rbenv/bin:$PATH\"
eval \"$(rbenv init -)\"

# Pyenv
export PYENV_ROOT=\"$HOME/.pyenv\"
[[ -d $PYENV_ROOT/bin ]] && export PATH=\"$PYENV_ROOT/bin:$PATH\"
eval \"$(pyenv init -)\"

# Direnv
eval \"$(direnv hook zsh)\"

# Zoxide
eval "$(zoxide init zsh)"
source <(fzf --zsh)
# eval \"$(fzf --zsh)\" OLD

# History
export HISTFILESIZE=1000000000
export HISTSIZE=1000000000
setopt INC_APPEND_HISTORY
export HISTTIMEFORMAT=\" [%F %T] \"
setopt EXTENDED_HISTORY

# Aliases
if [ -f ~/.zalias ]; then
    . ~/.zalias
fi" >> ~/.zprofile

# Create zalias file - TODO: add aliases when created
touch ~/.zalias
