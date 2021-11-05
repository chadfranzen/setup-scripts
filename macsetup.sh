#!/bin/bash

echo "${green}${bold}==== New Mac Setup================${reset}"
echo "${green}This script will install the basic tools you'll need to start developing."
echo "It will:"
echo " - Install xcode and homebrew"
echo " - Configure git with a new SSH key"
echo " - Install some useful command line tools"
echo " - Install some apps useful for development (browsers, IDEs, etc)"
echo "It won't overwrite anything you already have installed.${reset}"
read -p "${bold}${red}Press ENTER to get started: ${reset}"

brew_install() {
    if brew list $1 &>/dev/null; then
        echo "${cyan}${1} is already installed, skipping${reset}"
    else
        echo "${yellow}Installing $1...${reset}"
        brew install $1 && echo "${green}$1 is now installed${reset}"
    fi
}

cask_install() {
    # Check if it was already installed via brew or if it was installed manually
    # to the Applications folder. This isn't perfect, but it's a good heuristic.
    if [ brew list $1 &>/dev/null ] || [ -d "/Applications/$2.app" ]; then
        echo "${cyan}${2} is already installed, skipping${reset}"
    else
        echo "${yellow}Installing $2...${reset}"
        brew install --cask $1 && echo "${green}$2 is now installed${reset}"
    fi
}

bold=`tput bold`
red=`tput setaf 1`
green=`tput setaf 2`
yellow=`tput setaf 3`
cyan=`tput setaf 6`
reset=`tput sgr0`

echo "${bold}==== Xcode ================${reset}"
if type xcode-select >&- && xpath=$( xcode-select --print-path ) &&
   test -d "${xpath}" && test -x "${xpath}" ; then
  echo "${cyan}Xcode tools are already installed.${reset}"
else
  echo "${yellow}Installing xcode tools...${reset}"
  xcode-select --install
  echo "${green}xcode tools installed.${reset}"
fi

echo ""

echo "${bold}==== Homebrew =============${reset}"
if test ! $(which brew); then
  echo "${yellow}Installing homebrew...${reset}"
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  echo "${yellow}Writing to .zprofile...${reset}"
  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
  echo "${green}Done. NOTE: You may need to refresh your terminal before you can use brew${reset}"
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  echo "${cyan}Homebrew is already installed.${reset}"
fi

echo "Updating homebrew..."
brew update

echo ""

echo "${bold}==== Git ==================${reset}"
brew_install "git"

if [ ! -f "$HOME/.ssh/id_rsa" ]; then
  echo "Creating an SSH key to use with Github..."
  ssh-keygen -t rsa
  echo "${red}${bold}Please add this public key to Github at: https://github.com/account/ssh${reset}"
  read -p "${red}${bold}Press ENTER key after you're done...${reset}"
else
  echo "${cyan}Not generating SSH key because it already exists at ~/.ssh/id_rsa.${reset}"
  echo "${cyan}Be sure to add this key to Github if you haven't.${reset}"
fi

read -p "${red}${bold}Enter the name you want to use for Github (typically first + last name, ENTER to skip): ${reset}" githubuser
if [ ! -z "$githubuser" ]; then
  echo "${yellow}Setting username${reset}"
  git config --global --unset-all user.name
  git config --global user.name "$githubuser"
else
  echo "${cyan}Skipping${reset}"
fi

read -p "${red}${bold}Enter your Github email (ENTER to skip): ${reset}" githubemail
if [ ! -z "$githubemail" ]; then
  echo "${yellow}Setting email${reset}"
  git config --global --unset-all user.email
  git config --global user.email "$githubemail"
else
  echo "${cyan}Skipping${reset}"
fi

echo "${green}All done. You can change these settings at any time with 'git config --global user.name' and 'git config --global user.email'${reset}"

echo ""

echo "${bold}==== Brew =================${reset}"
echo "Installing some basic brew tools..."
echo ""
brew_install "wget"
brew_install "curl"
brew_install "node"
brew_install "gh"
brew_install "python3"
brew_install "tmux"
brew_install "pyenv"
brew_install "yarn"
brew_install "nvm"
brew_install "svn"

echo ""

echo "Installing some GUI apps..."
echo ""
cask_install "iterm2" "iTerm"
cask_install "google-chrome" "Google Chrome"
cask_install "firefox" "Firefox"
cask_install "zoom" "zoom.us"
cask_install "visual-studio-code" "Visual Studio Code"
cask_install "rectangle" "Rectangle"
cask_install "macvim" "MacVim"

echo "Cleaning up brew"

echo ""

echo "${bold}==== Configs ==============${reset}"

while true; do
  read -p "${red}${bold}Copy .vimrc and .tmux.conf from Github? (Y/n): ${reset}" yn
  case $yn in
    [Yy]* )
      echo "${yellow}Copying...${reset}"
      cd ~
      git clone git@github.com:chadfranzen/dotfiles.git .dotfiles
      cd .dotfiles
      mv .vimrc ~/.vimrc
      mv .tmux.conf ~/.tmux.conf
      echo "${yellow}Making sure Vim plugin manager is available...${reset}"
      mkdir -p ~/.vim/autoload ~/.vim/bundle
      curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
      git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
      echo "${green}Done. If you want a .zshrc as well, run zshsetup.sh after this.${reset}"
      break
      ;;
    [Nn]* ) break;;
  esac
done

while true; do
  read -p "${red}${bold}Add nvm to your .zshrc? You should do this if you haven't already done it manually (Y/n): ${reset}" yn
  case $yn in
    [Yy]* )
      touch $HOME/.zshrc
      echo 'export NVM_DIR=~/.nvm' >> $HOME/.zshrc
      echo '[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"' >> $HOME/.zshrc
      echo "${green}Done!${reset}"
      break
      ;;
    [Nn]* ) break;;
  esac
done

echo ""

echo "${bold}==== Misc =================${reset}"

brew_install "starship"

echo ""

echo "Installing Fira fonts..."
brew tap homebrew/cask-fonts
cask_install "font-fira-code font-fira-mono font-fira-mono-for-powerline font-fira-sans" "FiraCode"

echo ""

while true; do
  read -p "${red}${bold}Enable key repeating? This will make long key presses repeat a character instead of bringing up the accent menu. (Y/n): ${reset}" yn
  case $yn in
    [Yy]* )
      defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
      echo "${green}Done. You can disable this by running 'defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool true'${reset}"
      break
      ;;
    [Nn]* ) break;;
  esac
done

echo ""

cd ~
rm -rf .dotfiles

killall Finder

echo "${green}${bold}Setup complete!${reset}"
echo "${yellow}You may need to run '. ~/.zshrc' in this terminal window so your shell works properly.${reset}"
echo "${yellow}Next, you should go over to iterm2 and install oh-my-zsh via the following:${reset}"
echo "sh -c \"\$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)\""
