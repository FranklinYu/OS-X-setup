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
curl -sSL https://get.rvm.io | bash -s stable --ruby=2.2.2

# https://packagecontrol.io/installation