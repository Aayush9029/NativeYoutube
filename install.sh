

echo "Installing / Updating Homebrew"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

echo "Installing / Updating mpv and youtube dl"
brew install wget
brew install mpv youtube-dl
brew link youtube-dl
brew link mpv

cd Applications

echo "Downloading...."
wget https://github.com/Aayush9029/Native-Youtube/releases/download/v0.02/Muubii.app.zip
echo "Installing Muubbi"
ls
unzip -qq Muubii.app.zip

echo "Finishing up..."
rm -rf Muubii.app.zip
mv Muubii.app /Applications

echo "Successfully installed Muubbi! Check your applications!"

