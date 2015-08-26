# [Homebrew](http://brew.sh/)
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew_check() {
	if [$1 -ne 0]; then
		echo "$0: Can't install with Homebrew, exiting..."
		exit 1
	else
}

# install tools
brew install tree wget
brew_check $?

# SSH key
if [ -f ~/.ssh/id_rsa ]; then ssh-keygen -t rsa -f ~/.ssh/id_rsa -N ''; fi
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa

# RVM and Ruby
brew install gpg
brew_check $?
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
curl -sSL https://get.rvm.io | bash -s stable
rvm reset
# same as `rvm --default use system` after installing any ruby

# Git
full_name="$(dscl . -read /Users/`whoami` RealName | tr "\n" " " |
    sed 's/RealName: *//')"
git config --global user.name $full_name
git config --global user.email franklinyu@hotmail.com # should be variable
git config --global push.default simple

# Zsh
if [ -f ~/.zshrc ]; then echo >> ~/.zshrc; fi
cat suggested/.zshrc >> ~/.zshrc
