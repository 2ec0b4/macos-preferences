#!/usr/bin/env bash

if ! [ -x "$(command -v brew)" ]; then
    echo "Install Homebrew";
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

export HOMEBREW_CASK_OPTS="--appdir=/Applications"

echo "Install Homebrew core formulaes";
brew install bash
brew install bash-completion2

# Switch to using brew-installed bash as default shell
if ! fgrep -q '/usr/local/bin/bash' /etc/shells; then
  echo '/usr/local/bin/bash' | sudo tee -a /etc/shells;
  chsh -s /usr/local/bin/bash;
fi;

homebrew_packages=(
    "coreutils"
    "moreutils"
    "findutils"
    "cowsay"
    "dnsmasq"
    "git"
    "ffmpeg"
    "fortune"
    "mas"
    "node"
    "ssh-copy-id"
    "wget"
)

for homebrew_package in "${homebrew_packages[@]}"; do
    brew install "$homebrew_package"
done

echo "Upgrading npm";
npm install npm@latest -g

echo "Install node packages";
sudo npm install -g cordova ionic

echo "Install Homebrew Cask";
brew tap phinze/cask
brew install brew-cask

echo "Install Homebrew Cask apps";
# https://caskroom.github.io/search
homebrew_cask_packages=(
# Core apps
    "cakebrew"
    "flycut"
    "openoffice"
    "transmit"
    "vlc"
    "iterm2"
# Dev apps
    "android-studio"
    "android-file-transfer"
    "charles"
    "docker"
    "docker-toolbox"
    "fastlane"
    "firefox"
    "google-chrome"
    "mysqlworkbench"
    "poedit"
    "postman"
    "sequel-pro"
    "sourcetree"
    "vagrant"
    "vagrant-manager"
    "virtualbox"
# Nice to have
    "bitbar"
    #"boom"
    "daisydisk"
    "dash"
    "dashlane"
    "divvy"
    "headset"
    "kap"
    "opera-neon"
    "slack"
    "skype"
    "spotify"
    "xscope"
)

for homebrew_cask_package in "${homebrew_cask_packages[@]}"; do
    brew cask install "$homebrew_cask_package"
done;

read -p "Install Mac App Store apps (y/n)?" -n 1;
echo "";
if [[ $REPLY =~ ^[Yy]$ ]]; then
	echo "Install Mac App Store apps";
    mas signin
    mas_apps=(
        #"497799835" # XCode
    )

    for mas_app in "${mas_apps[@]}"; do
        mas install "$mas_app"
    done
fi;

echo "Get DevDocs as an app";
npm install -g nativefier
nativefier --name "DevDocs" --verbose --counter --icon app-icon.icns --fast-quit --flash "https://devdocs.io/";

echo "Cleanup";
brew cleanup --force
brew cask cleanup
rm -f -r /Library/Caches/Homebrew/*
