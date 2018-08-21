#!/usr/bin/env bash

CURRENT_PATH=$(pwd);

if ! [ -x "$(command -v brew)" ]; then
    echo "Install Homebrew";
    xcode-select --install
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
    "gradle"
    "ffmpeg"
    "fortune"
    "mas"
    "nvm"
    "ssh-copy-id"
    "wget"
)

for homebrew_package in "${homebrew_packages[@]}"; do
    brew install "$homebrew_package"
done

export NVM_DIR="$HOME/.nvm"
. "$(brew --prefix nvm)/nvm.sh"

nvm install --lts

echo "Upgrading npm";
npm install npm@latest -g

echo "Install node packages";
npm install -g cordova ionic gulp

echo "Install Homebrew Cask apps";
brew tap caskroom/cask
brew tap buo/cask-upgrade
# https://caskroom.github.io/search
homebrew_cask_packages=(
# Core apps
    "cakebrew"
    "flycut"
    "libreoffice"
    "vlc"
    "iterm2"
    "the-unarchiver"
# Dev apps
    "android-file-transfer"
    "android-platform-tools"
    "android-studio"
    "bbedit"
    "charles"
    "docker"
    "docker-toolbox"
    "fastlane"
    "firefox"
    "google-chrome"
    "mysqlworkbench"
    "phpstorm"
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
    "franz"
    "headset"
    "kap"
    "opera-neon"
    "slack"
    "spotify"
    "transmit"
    "xscope"
# Quick Look plugins (see https://github.com/sindresorhus/quick-look-plugins)
    "qlcolorcode"
    "qlstephen"
    "qlmarkdown"
    "quicklook-json"
    "qlimagesize"
    "webpquicklook"
    "suspicious-package"
    "quicklookase"
    "qlvideo"
)

for homebrew_cask_package in "${homebrew_cask_packages[@]}"; do
    brew cask install "$homebrew_cask_package"
done;

# Restart Quick Look
qlmanage -r

echo "PHP Tools";
brew tap homebrew/dupes
brew tap homebrew/php
brew install php@7.1
brew install mcrypt
brew install composer
composer global require "squizlabs/php_codesniffer=3.*"
composer global require "phpmd/phpmd=2.*"

if ! [ -a "/Applications/nativefier/DevDocs-darwin-x64/DevDocs.app" ]; then
    if ! [ -x "$(command -v nativefier)" ]; then
        echo "Install nativefier";
        npm install -g nativefier
    fi
	echo "Get https://devdocs.io/ as an app";
    app_icon=${CURRENT_PATH}"/ressources/nativefier/app-icon.icns";
    mkdir /Applications/nativefier > /dev/null 2>&1;
    cd /Applications/nativefier;
    nativefier --name "DevDocs" --verbose --no-overwrite --counter --icon ${app_icon} --fast-quit "https://devdocs.io/";
    cd -;
fi

read -p "Install Mac App Store apps (y/n)?" -n 1;
echo "";
if [[ $REPLY =~ ^[Yy]$ ]]; then
	echo "Install Mac App Store apps";
    mas signin
    mas_apps=(
        "497799835" # XCode
    )

    for mas_app in "${mas_apps[@]}"; do
        mas install "$mas_app"
    done
fi;

echo "Cleanup";
brew cleanup --force
brew cask cleanup
rm -f -r /Library/Caches/Homebrew/*
