
echo "Checking /Installing"
if ! type brew > /dev/null;
then
echo "Installing Homebrew..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
echo "Installing / Checking dependencies"
if brew ls --versions mpv && brew ls --versions youtube-dl > /dev/null;
then
echo "Not installing because the packages already exist"
else
echo "Installing Dependencies"
brew install mpv
brew install youtube-dl
brew link mpv
brew link youtube-dl

fi

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
