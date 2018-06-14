# Show hidden files in Finder
defaults write com.apple.finder AppleShowAllFiles YES
killall Finder

# Change default screenshot location to ~/Downloads
defaults write com.apple.screencapture location $HOME/Downloads

# Show battery percentage on top menu bar
defaults write com.apple.menuextra.battery ShowPercent YES
killall SystemUIServer

# Disble time machine when new media inserted to the system
sudo defaults write /Library/Preferences/com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

# Don't write DS_Store file on USB and network drive
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
