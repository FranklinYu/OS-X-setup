set -o errexit -o pipefail -o nounset

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
	elif grep --fixed-strings --quiet "$2" "$1"; then
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
brew bundle install --file=suggested/Brewfile

# SSH
if [ ! -f ~/.ssh/id_rsa ]; then ssh-keygen -t rsa -f ~/.ssh/id_rsa -N ''; fi
sudo patch --strip=0 < suggested/ssh_config.patch

# Ruby
sudo gem update --system # `RUBYGEMS_GEMDEPS` requires RubyGems >= 2.2.0
ensure_include ~/.irbrc 'IRB.conf[:PROMPT_MODE] = :SIMPLE'

# Git
full_name_default="$(dscl . -read /Users/`whoami` RealName | tr "\n" " " |
    sed 's/RealName: *//')"
git config --global user.name "${FULL_NAME:=$full_name_default}"
echo "Using $FULL_NAME as Git username."
git config --global user.email "$EMAIL"
git config --global push.default simple

# Zsh
mkdir -p ~/.config/zsh
mkdir -p ~/.local/share/zsh
if [ -f ~/.zshrc ]; then echo >> ~/.zshrc; fi
cat suggested/zshrc.zsh >> ~/.zshrc
cp suggested/zprofile.zsh ~/.zprofile
cp suggested/aliases.zsh ~/.config/zsh/aliases

# Vim
cp suggested/.vimrc ~/.vimrc

# Atom home
cp suggested/io.atom.setting.homedir.plist ~/Library/LaunchAgents/
