"""Restore tabs after Great Suspender Chrome extension upgrade"""
## Requirements
# pyperclip

import pyperclip

def main():
    print('Listening for new pastes in clipboard...')

    while 1:
        pyperclip.waitForNewPaste()
        paste = pyperclip.paste()

        if 'chrome-extension://' in paste:
            new_url = paste.split('uri=')[1]
            pyperclip.copy(new_url)
            print(f"Fixed URL: {new_url}")

try:
    main()
except KeyboardInterrupt:
    exit(0)