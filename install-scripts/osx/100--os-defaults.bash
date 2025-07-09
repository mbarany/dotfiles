# Show hidden files in Finder
defaults write com.apple.finder AppleShowAllFiles YES
killall Finder

# Change default screenshot location to ~/Downloads
defaults write com.apple.screencapture location ${HOME}/Downloads

# Show battery percentage on top menu bar
defaults write ~/Library/Preferences/ByHost/com.apple.controlcenter.plist BatteryShowPercentage -bool true

# Disable time machine when new media inserted to the system
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

# Don't write DS_Store file on USB and network drive
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# Menubar spacing for showing more icons
defaults -currentHost write -globalDomain NSStatusItemSpacing 6
defaults -currentHost write -globalDomain NSStatusItemSelectionPadding 6

# Autohide the Dock
defaults write com.apple.dock autohide -bool true; killall Dock

# Single tap on trackpad
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
/System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
