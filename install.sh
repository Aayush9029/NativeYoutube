
echo "Installing / Updating Homebrew"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

echo "Installing / Updating mpv and youtube dl"
brew install mpv youtube-dl wget
brew link youtube-dl
brew link mpv
brew link wget


echo "Downloading..."
cd ~/../../Applications
wget https://github.com/Aayush9029/Native-Youtube/releases/download/v0.02/Muubii.app.zip > /dev/null 2>&1



echo "Installing"
unzip -qq Muubii.app.zip
rm Muubii.app.zip

echo "Installed"

echo "Exiting terminal in 3"
sleep 1
echo "2"
sleep 1
echo "1"
sleep 1
exit
