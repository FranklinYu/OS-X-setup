set -e -o pipefail

print_info() {
	tput setaf 2
	echo "$@"
	tput sgr 0
}

# Ensure that a file exist and contains some string
#
# $1 filename
# $2 a string to be included in the file
# $3 (optional) a phrase describing $2. Empty string is regarded as missing.
ensure_include() {
	if ! [ -f abc ]; then
		echo "$2" > "$1"
		print_info "file <$1> created" ${3:+with "$3"}
	elif fgrep --quiet "$2" "$1"; then
		print_info "file <$1> already contains" ${3:-'necessary string'}
	else
		print_info "file <$1> appended" ${3:+with "$3"}
		echo >> "$1" # blank line
		echo "$2" >> "$1"
	fi
}

# [Homebrew](http://brew.sh/)
if /usr/bin/which -s brew; then
	print_info 'Homebrew found; installation skipped.'
else
	hb_url='https://raw.githubusercontent.com/Homebrew/install/master/install'
	curl --fail --silent --show-error --location $hb_url | ruby
fi
brew tap Homebrew/bundle
brew bundle install

# SSH key
if [ ! -f ~/.ssh/id_rsa ]; then ssh-keygen -t rsa -f ~/.ssh/id_rsa -N ''; fi
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa

# RVM and Ruby
gpg --keyserver hkp://keys.gnupg.net \
	--recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
curl --fail --silent --show-error --location https://get.rvm.io | bash -s stable
ensure_include ~/.irbrc 'IRB.conf[:PROMPT_MODE] = :SIMPLE'

# Git
full_name_default="$(dscl . -read /Users/`whoami` RealName | tr "\n" " " |
    sed 's/RealName: *//')"
git config --global user.name "${full_name:=$full_name_default}"
echo Using $full_name as Git username.
git config --global user.email franklinyu@hotmail.com # should be variable
git config --global push.default simple

# Zsh
if [ -f ~/.zshrc ]; then echo >> ~/.zshrc; fi
cat suggested/.zshrc >> ~/.zshrc
cp suggested/.bash_aliases ~/.bash_aliases

# Vim
cp suggested/.vimrc ~/.vimrc
