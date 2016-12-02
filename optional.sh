########################
# Zsh theme 'agnoster' #
########################

sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="agnoster"/' ~/.zshrc

# install Powerline fonts for theme 'agnoster'
font_dir=`mktemp -d`
if [$? -ne 0]; then
	echo "$0: Can't create temp folder, exiting..."
	exit 1
fi
git clone https://github.com/powerline/fonts.git font_dir
if [$? -ne 0]; then
	echo "$0: Can't clone font repository, exiting..."
	exit 1
else
	$font_dir/install.sh
fi

# set default user
if [ -f ~/.zshrc ]; then echo >> ~/.zshrc; fi
echo "# for theme 'agnoster'" >> ~/.zshrc
echo "export DEFAULT_USER=`whoami`" >> ~/.zshrc
