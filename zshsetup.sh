#!/bin/bash

brew_install() {
    if brew list $1 &>/dev/null; then
        echo "${cyan}${1} is already installed, skipping${reset}"
    else
        echo "${yellow}Installing $1...${reset}"
        brew install $1 && echo "${green}$1 is now installed${reset}"
    fi
}

bold=`tput bold`
red=`tput setaf 1`
green=`tput setaf 2`
yellow=`tput setaf 3`
cyan=`tput setaf 6`
reset=`tput sgr0`

echo "${bold}==== Zsh Setup ============${reset}"
echo "${red}This should be run after you install oh-my-zsh${bold}"
read -p "${bold}${red}Press ENTER to get started: ${reset}"

echo ""

echo "${yellow}Installing zsh plugins...${reset}"
brew_install "autojump"
git clone https://github.com/zsh-users/zsh-autosuggestions.git ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

echo ""

echo "${yellow}Copying .zshrc and starship.toml from Github...${reset}"
cd ~
git clone git@github.com:chadfranzen/dotfiles.git .dotfiles
cd .dotfiles
mkdir -p ~/.config
mv .zshrc ~/.zshrc
mv starship.toml ~/.config/starship.toml
cd ~
rm -rf .dotfiles

echo ""

echo "${green}Done!${reset}"
echo "${green}Be sure to source ~/.zshrc.${reset}"
