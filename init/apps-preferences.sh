#!/usr/bin/env bash

###############################################################################
# iTerm2                                                                      #
###############################################################################

# Install the Solarized Dark theme for iTerm
open "${CURRENT_PATH}/ressources/iTerm2/Solarized Dark.itermcolors"

# Don’t display the annoying prompt when quitting iTerm
defaults write com.googlecode.iterm2 PromptOnQuit -bool false

###############################################################################
# Personnalize the Dock                                                                      #
###############################################################################

# Wipe all (default) app icons from the Dock
defaults write com.apple.dock persistent-apps -array

apps_to_dock=(
    #"Finder"	#default
    "Calendar"
    "Mail"
    "Headset"
    "Spotify"
    "Dashlane"
    "-"
    "Skype"
    "Slack"
    "nativefier/DevDocs-darwin-x64/DevDocs"
    "SourceTree"
    "BBEdit"
    "PhpStorm"
    "Safari"
    "Google Chrome"
    "Firefox"
    "Opera Neon"
    "Postman"
    "Sequel Pro"
    "Transmit"
    "iTerm"
)

for app_to_dock in "${apps_to_dock[@]}"; do
echo ${app_to_dock};
    if [ "${app_to_dock}" = "-" ]; then
        echo "spacer";
        defaults write com.apple.dock persistent-apps -array-add '{"tile-type"="small-spacer-tile";}';
    else
        defaults write com.apple.dock persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/${app_to_dock}.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>"
    fi
done

###############################################################################
# Kill affected applications                                                  #
###############################################################################

for app in "Finder" \
	"iTerm2" \
	"Dock"; do
	killall "${app}" &> /dev/null
done
echo "Done. Note that some of these changes require a logout/restart to take effect."
