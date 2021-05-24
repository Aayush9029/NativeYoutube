
echo "Installing / Updating Homebrew"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

echo "Installing / Updating mpv and youtube dl"
brew install mpv youtube-dl wget
brew link youtube-dl
brew link mpv
brew link wget

echo "Downloading..."
wget https://github.com/Aayush9029/Native-Youtube/releases/download/v0.02/Muubii.app.zip > /dev/null 2>&1

echo "Unzipping the file"
unzip -qq Muubii.app.zip

echo "removing cache"
rm Muubii.app.zip

echo "Saving to your Applications folder"
mv Muubii.app /Applications

echo "Installed"

echo "Exiting terminal in 3"
sleep 2
echo "2"
sleep 1
echo "1"
sleep 1
exit
