# Mubbii

### Alpha 4.0 update, 2021, Sept 1

*Works on macos 11.0 and later**


![Screen Shot 2021-05-23 at 4 10 32 AM](https://user-images.githubusercontent.com/43297314/119253059-55d10580-bb7d-11eb-9beb-fd4453ada82a.png)

![Screen Shot 2021-05-23 at 4 07 53 AM](https://user-images.githubusercontent.com/43297314/119253119-aa748080-bb7d-11eb-9aa2-756b8d81b83e.png)

---

## Installation 

[Watch the Youtube Tutorial](https://www.youtube.com/watch?v=WrFPERZb7uw)

### Automatic install (recommended)
 - Open Terminal. 
 - Paste the line below, once done check your applications folder.
 - Ctrl + Click the app 
 - Done.
 
```bash
/bin/bash -c "$(curl https://raw.githubusercontent.com/Aayush9029/Native-Youtube/main/install.sh)"
```

### or (manual)

---

1. [HomeBrew](https://brew.sh)
```bash 
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

---

2. [MPV](https://formulae.brew.sh/formula/mpv) and [youtube-dl](https://formulae.brew.sh/formula/youtube-dl)
```bash 
 brew install mpv youtube-dl
 ```

---
  
3. [Download app](https://github.com/Aayush9029/Native-Youtube/releases/download/v0.003/Muubii.app.zip)
```bash
cd ~/Desktop; wget https://github.com/Aayush9029/Native-Youtube/releases/download/v0.003/Muubii.app.zip
```

4. [Run setp.py file](https://raw.githubusercontent.com/Aayush9029/Native-Youtube/main/setup.py)
* pass oauth token as second argument*
*eg `python3 setup.py YOUR_OAUTH_TOKEN`
```bash
wget https://raw.githubusercontent.com/Aayush9029/Native-Youtube/main/setup.py; python3 setup.py
```

** Even more manual?**
- Ditch the setup.py, copy [config-example.json](https://github.com/Aayush9029/Native-Youtube/blob/main/config-example.json
) file to ~/.mubbi/config.json
- Edit the config.json file to suit your needs and done.
  
---
  
Usage:

*Run install.sh, paste oauth key. let it do the rest of the setup.*
  
 ### How do I Get a YouTube API Key?
 
1. Log in to [Google Developers Console](https://console.developers.google.com/), Here's [The Official Documentation](https://developers.google.com/youtube/v3/getting-started#before-you-start) *follow step 2 and 3*
2. Create a new project.
3. On the new project dashboard, click Explore & Enable APIs.
4. In the library, navigate to YouTube Data API v3 under YouTube APIs.
5. Enable the API.
6. Create a credential.
7. A screen will appear with the API key.


----

*Submit new PRs on develop branch*

---

FAQ: 

Why no clean code structure?
 - Working on it. (35% there)
  
How do I donate?
- You don't need to, [but feel free to checkout some of my other apps](https://apps.apple.com/ca/developer/aayush-pokharel/id1532440924)

Where should I input the api keys?
- The when you run install.sh it will prompt you with a place to enter it + you can always edit ~/.mubbi/config.json 
- `vi ~/.mubbi.config.json` after running install.sh ie

---

> NEWS
> 
> *New: added a youtube tutorial for ease of installation*
> 
> *New: upload date looks a lot cleaner now, 2 mpv won't be created now*
> 
> *Note: To update run the automatic install once*

> Thanks to:
> 
> [Insomnia-creator](https://github.com/insomnia-creator)
>
> [Nathom](https://github.com/nathom)


If you also have an iPhone checkout
# [Rifi](https://aayush9029.github.io/RifiApp/)

*It's pretty neat imo*
