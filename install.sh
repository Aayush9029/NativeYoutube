
echo "Installing / Updating Homebrew"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

echo "Installing / Updating mpv and youtube dl"
brew install mpv youtube-dl
brew link youtube-dl
brew link mpv

echo "Downloading..."
cd /Applications
curl -LO https://github.com/Aayush9029/Native-Youtube/releases/download/v0.02/Muubii.app.zip

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
