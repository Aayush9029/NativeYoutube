# Native-Youtube
Personal App that turned into "alpha released app"

<img src="https://raw.githubusercontent.com/Aayush9029/Native-Youtube/main/ReadmeAssets/lofi.png"> <img src="https://raw.githubusercontent.com/Aayush9029/Native-Youtube/main/ReadmeAssets/mkbhd.png"> <img src="https://raw.githubusercontent.com/Aayush9029/Native-Youtube/main/ReadmeAssets/settings-image.png" width='440px'>

## Requirements:

- MacOS 12.0 or above
- [HomeBrew](https://brew.sh/)
  - ```/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"```
- [youtube-dl](https://formulae.brew.sh/formula/youtube-dl)
   - ```brew install youtube-dl```
- [mpv](https://formulae.brew.sh/cask/mpv)
  - ```brew install mpv```
- *A working google account*

## Usage
### Download the universal binary from the releases tab.
- Open the app *It's a menu bar app*

- Click on the gear icon > paste your api key, mpv and youtube-dl path and you're done.


## FAQ:

> **Where's the non menu bar version that worked on BigSur?**

It's in the [oldApp branch](https://github.com/Aayush9029/Native-Youtube/tree/OldApp)
It is no longer being maintained however there are forks of the "old version" which are being maintained.
*Note: The codebase for oldApp is very bad as it was hacked together in couple hours*

> **How do I Get a YouTube API Key?**
1. Log in to Google Developers Console, Here's The Official Documentation follow step 2 and 3
2. Create a new project.
3. On the new project dashboard, click Explore & Enable APIs.
4. In the library, navigate to YouTube Data API v3 under YouTube APIs.
5. Enable the API.
6. Create a credential.
7. A screen will appear with the API key.

*Here's a [video link](https://www.youtube.com/watch?v=WrFPERZb7uw) for old version of app, process of api key retrival is similar*
