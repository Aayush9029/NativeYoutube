#!/bin/bash

if ! type brew > /dev/null
then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

echo "Installing / Updating mpv and youtube dl"
brew install mpv youtube-dl
brew link youtube-dl
brew link mpv

echo "Downloading..."
wget https://github.com/Aayush9029/Native-Youtube/releases/download/v0.02/Muubii.app.zip > /dev/null 2>&1

echo "Unzipping the file"
unzip -qq Muubii.app.zip

echo "removing cache"
rm Muubii.app.zip

echo "Saving to your Applications folder"
mv Muubii.app /Applications

echo "DONE :)"
