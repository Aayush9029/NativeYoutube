# import json and os
import json
import os
import sys

# get all args
args = sys.argv

# get the second arg which should be the auth_token
auth_token = args[1]

# if auth_token is not set ask for it
if auth_token is None:
    auth_token = input("Enter Youtube Auth Token: ")

    
    
    

# get installation path of youtube-dl
youtube_dl_path = os.popen("which youtube-dl").read().rstrip()

# get installation path of mpv
mpv_path = os.popen("which mpv").read().rstrip()

# print installation paths and auth token
print("your youtube-dl path: " + youtube_dl_path)
print("your mpv path: " + mpv_path)
print("your auth token: " + auth_token)

# print you can configure this in the config.json file
print("you can configure this in the config.json file")

# show path to config.json
print("path to config.json: " +
      os.path.join(os.path.expanduser("~"), "config.json"))


# Here's an example of json structure.
# {
#     "AuthToken": "",
#     "MpvPath": "",
#     "YoutubedlPath": ""
# }

#  get home directory
home_dir = os.path.expanduser("~")


# create a new directory in home/.mubbi/
if not os.path.exists(home_dir + "/.mubbi"):
    os.makedirs(home_dir + "/.mubbi")

# make a new file in home/.mubbi directory named config.json
# and write installation paths to file
with open(home_dir + "/.mubbi/config.json", "w") as f:
    json.dump({
        "AuthToken": auth_token,
        "MpvPath": mpv_path,
        "YoutubedlPath": youtube_dl_path
    }, f, indent=4)

    

#  In cause you're wondering about weird comment formatting,
# 95% of the code was written by github co-pilot :D
