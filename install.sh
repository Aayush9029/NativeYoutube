#!/bin/bash

echo "Installing / Updating Homebrew"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

echo "Installing / Updating mpv and youtube dl"
brew install mpv youtube-dl

echo "\n\nDownloading..."
wget https://github.com/Aayush9029/Native-Youtube/releases/download/v0.01/Native.Youtube.app.zip > /dev/null 2>&1

echo "Unzipping the file"
unzip -qq Native.Youtube.app.zip

echo "removing cache"
rm Native.Youtube.app.zip

echo "Saving to your Applications folder"
mv Native\ Youtube.app /Applications

echo "\nDONE :)"

echo "Exiting terminal in 3"
sleep 2
echo "2"
sleep 1
echo "1"
sleep 1
exit
