echo "Installing xcode-stuff"
xcode-select --install

# Check for Homebrew,
# Install if we don't have it
if test ! $(which brew); then
  echo "Installing homebrew..."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Update homebrew recipes
echo "Updating homebrew..."
brew update

echo "Installing Git..."
brew install git

echo "Creating an SSH key..."
ssh-keygen -t rsa

echo "Please add this public key to Github \n"
echo "https://github.com/account/ssh \n"
read -p "Press [Enter] key after this..."


echo "Git config"
echo "Setting git email to chadfranzen95@gmail.com"
echo "You can change this via 'git config --global user.email <email>'"

git config --global user.name "Chad Franzen"
git config --global user.email chadfranzen95@gmail.com


echo "Installing some yummy brew tools..."
brew install wget
brew install curl
brew install node
brew install gh
brew install python3
brew install tmux
echo "Installing iterm2 and some plugins..."
brew install --cask iterm2
brew install starship
echo "Installing Fira fonts..."
brew tap homebrew/cask-fonts
brew install --cask font-fira-code font-fira-mono font-fira-mono-for-powerline font-fira-sans

echo "Cleaning up brew"
brew cleanup

echo "Copying .vimrc, .tmux.conf, and .zshrc from Github"
cd ~
git clone git@github.com:chadfranzen/dotfiles.git .dotfiles
cd .dotfiles
mv .vimrc ~/.vimrc
mv .tmux.conf ~/.tmux.conf
echo "Not copying .zshrc. Run zshsetup.sh after this to copy that."

cd ~
rm -rf .dotfiles

echo "Setting up key repeat (you should also configure the speed in Settings)"
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

killall Finder


echo "Done!"
echo "Next, you should go over to iterm2 and install oh-my-zsh via the following:"
echo "sh -c \"\$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)\""
