#!/bin/bash
# CREDIT/original: https://gist.github.com/kimmobrunfeldt/350f4898d1b82cf10bce
# Updated for modern macOS (Sequoia/Sonoma and later)

set -e  # Exit on error

echo "Applying macOS system preferences..."
echo ""

###############################################################################
# General UI/UX                                                               #
###############################################################################

echo "→ Disable the 'Are you sure you want to open this application?' dialog"
defaults write com.apple.LaunchServices LSQuarantine -bool false

echo "→ Disable auto-correct"
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

echo "→ Show percentage in battery status"
defaults write com.apple.menuextra.battery ShowPercent -string "YES"
defaults write com.apple.menuextra.battery ShowTime -string "NO"

echo "→ Show all filename extensions in Finder"
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

echo "→ Expand save panel by default"
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true

echo "→ Expand print panel by default"
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true

echo "→ Show the ~/Library folder"
chflags nohidden ~/Library

echo "→ Show the /Volumes folder"
sudo chflags nohidden /Volumes

###############################################################################
# Finder                                                                      #
###############################################################################

echo "→ Use current directory as default search scope in Finder"
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

echo "→ Show Path bar in Finder"
defaults write com.apple.finder ShowPathbar -bool true

echo "→ Show Status bar in Finder"
defaults write com.apple.finder ShowStatusBar -bool true

echo "→ Avoid creating .DS_Store files on network volumes"
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

echo "→ Avoid creating .DS_Store files on USB volumes"
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

echo "→ Disable the warning when changing a file extension"
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

echo "→ Use column view in all Finder windows by default"
# Four-letter codes for view modes: icnv (icon), Nlmv (list), clmv (column), Flwv (gallery)
defaults write com.apple.finder FXPreferredViewStyle -string "clmv"

echo "→ Show hidden files in Finder"
defaults write com.apple.finder AppleShowAllFiles -bool true

echo "→ Keep folders on top when sorting by name"
defaults write com.apple.finder _FXSortFoldersFirst -bool true

###############################################################################
# Dock                                                                        #
###############################################################################

echo "→ Disable automatic rearrangement of spaces based on most recent usage"
defaults write com.apple.dock mru-spaces -bool false

echo "→ Don't show recent applications in Dock"
defaults write com.apple.dock show-recents -bool false

echo "→ Minimize windows into application icon"
defaults write com.apple.dock minimize-to-application -bool true

echo "→ Set Dock icon size"
defaults write com.apple.dock tilesize -int 48

echo "→ Enable Dock autohide"
defaults write com.apple.dock autohide -bool true

echo "→ Remove autohide delay"
defaults write com.apple.dock autohide-delay -float 0

echo "→ Speed up Mission Control animations"
defaults write com.apple.dock expose-animation-duration -float 0.1

###############################################################################
# Screenshots                                                                 #
###############################################################################

echo "→ Save screenshots to ~/Pictures/Screenshots"
defaults write com.apple.screencapture location -string "$HOME/Pictures/Screenshots"

echo "→ Save screenshots in PNG format"
# Options: PNG, BMP, GIF, JPG, PDF, TIFF
defaults write com.apple.screencapture type -string "png"

echo "→ Disable screenshot thumbnail preview"
defaults write com.apple.screencapture show-thumbnail -bool false

echo "→ Disable shadow in screenshots"
defaults write com.apple.screencapture disable-shadow -bool true

###############################################################################
# Security & Privacy                                                          #
###############################################################################

echo "→ Require password immediately after sleep or screen saver begins"
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

###############################################################################
# Keyboard & Input                                                            #
###############################################################################

echo "→ Enable full keyboard access for all controls"
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

echo "→ Set fast keyboard repeat rate"
defaults write NSGlobalDomain KeyRepeat -int 2

echo "→ Set short delay until key repeat"
defaults write NSGlobalDomain InitialKeyRepeat -int 15

echo "→ Disable press-and-hold for keys in favor of key repeat"
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

###############################################################################
# Trackpad & Mouse                                                            #
###############################################################################

echo "→ Use scroll gesture with Ctrl modifier key to zoom"
defaults write com.apple.universalaccess closeViewScrollWheelToggle -bool true
defaults write com.apple.universalaccess HIDScrollZoomModifierMask -int 262144

echo "→ Follow mouse when zoomed in"
defaults write com.apple.universalaccess closeViewPanningMode -int 0

echo "→ Enable tap to click for trackpad"
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

echo "→ Enable three finger drag"
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool true
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true

###############################################################################
# Control Center (macOS Big Sur+)                                             #
###############################################################################

echo "→ Show Bluetooth in menu bar"
defaults write com.apple.controlcenter "NSStatusItem Visible Bluetooth" -bool true

echo "→ Show Sound in menu bar"
defaults write com.apple.controlcenter "NSStatusItem Visible Sound" -bool true

###############################################################################
# Activity Monitor                                                            #
###############################################################################

echo "→ Sort Activity Monitor results by CPU usage"
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection -int 0

echo "→ Show all processes in Activity Monitor"
defaults write com.apple.ActivityMonitor ShowCategory -int 0

###############################################################################
# TextEdit                                                                    #
###############################################################################

echo "→ Use plain text mode for new TextEdit documents"
defaults write com.apple.TextEdit RichText -int 0

echo "→ Open and save files as UTF-8 in TextEdit"
defaults write com.apple.TextEdit PlainTextEncoding -int 4
defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4

###############################################################################
# Apply Changes                                                               #
###############################################################################

echo ""
echo "Restarting affected applications..."
for app in "Activity Monitor" "Dock" "Finder" "SystemUIServer"; do
    killall "$app" &> /dev/null || true
done

echo ""
echo "✓ System preferences applied successfully!"
echo ""
echo "Note: Some changes may require a logout or restart to take full effect."
