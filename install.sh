CYAN_IS_SUS="\033[0;36m"
RED="\033[0;31m"
YELLOW="\033[0;33m"
PURPLE="\033[0;35m"
GREEN="\033[0;32m"

echo "${YELLOW}Checking / ${RED}Installing"
if ! type brew > /dev/null;
then
echo "${CYAN_IS_SUS}Installing ${GREEN}Homebrew..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
echo "${PURPLE}Installing / ${YELLOW}Checking dependencies"
if brew ls --versions mpv && brew ls --versions youtube-dl > /dev/null;
then
echo "${GREEN}Not installing because the packages already exist"
else
echo "${CYAN_IS_SUS}Installing Dependencies"
brew install mpv
brew install youtube-dl
brew link mpv
brew link youtube-dl

fi

echo "${YELLOW}Downloading..."
cd /Applications
curl -LO https://github.com/Aayush9029/Native-Youtube/releases/download/v0.02/Muubii.app.zip

echo "${GREEN}Installing"
unzip -qq Muubii.app.zip
rm Muubii.app.zip

echo "${PURPLE}Installed"

echo "${CYAN_IS_SUS}Exiting terminal in 3"
sleep 1
echo "${RED}2"
sleep 1
echo "${YELLOW}1"
sleep 1
exit
