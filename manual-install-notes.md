# Don't forget to do these manual steps!

## Install Fritzing

```bash
echo "Opening Fritzing page to download since it is not available in homebrew or the app store..."
open "https://fritzing.org/releases" # Check "Fritzing Personal Download link" in lastpass
```

## Activate Dash and Import Docsets

```bash
echo "Opening Dash license file in Google Drive (please sign in to access)"
open "https://drive.google.com/drive/folders/1oHmVzp69sv16xqpgjw2rJdM-1N1RIoEz?usp=drive_link" # Link to Dash
```

To import Docsets, go to "Settings > General" and then hit "Set Up Syncing..." at the very bottom

Hit "Set Sync Folder" and set it to the ./dash-docsets/Dash.dashsync folder in this repo.

## Create initital tmux ressurect session

From within a tmux session, hit Ctrl-B + Ctrl-s to save an initial tmux session. All future sessions with be automatically persisted.
