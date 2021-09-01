echo "Your Oauth Token"
read -p "> " TOKEN

echo "Checking / Installing"
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
fi

echo "Deleting older installation if it exists"
rm -rf /Applications/Muubii.app/

echo "Downloading..."
cd /Applications
curl -LO https://github.com/Aayush9029/Native-Youtube/releases/download/v0.003/Muubii.app.zip

echo "Installing"
unzip -qq Muubii.app.zip

echo "Removing .zip file"
rm Muubii.app.zip

echo "Removing quarantine"
xattr -dr com.apple.quarantine Muubii.app

echo "Installed..."

#  Why python? Because it's easy to install, *written by co-pilot
echo "Creating config file"
wget https://raw.githubusercontent.com/Aayush9029/Native-Youtube/main/setup.py; python3 setup.py $TOKEN




open Muubii.app
echo "Exiting terminal in 3 seconds"
sleep 1
echo "Exiting terminal in 2 seconds"
sleep 1 
echo "Exiting terminal in 1 second"

sleep 1
exit
