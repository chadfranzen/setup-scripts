echo "Setting up zsh"
echo "This should be run after you install oh-my-zsh"

echo "Installing zsh plugins..."
brew install autojump
git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
echo "Copying .zshrc and starship.toml from Github..."
cd ~
git clone git@github.com:chadfranzen/dotfiles.git .dotfiles
cd .dotfiles
mkdir -p ~/.config
mv .zshrc ~/.zshrc
mv starship.toml ~/.config/starship.toml
cd ~
rm -rf .dotfiles
echo "Done!"
echo "Be sure to source ~/.zshrc."
