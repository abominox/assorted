#/usr/bin/env python3

"""Pushover Notifier"""

# Send Pushover notification when torrent downloads.
# This file is called by qbittorrent-nox

import argparse
import json
import requests

def main():
    """Main Function"""

    parser = argparse.ArgumentParser()
    parser.add_argument('--name', '-n', dest='torrent_name')
    args = vars(parser.parse_args())

    data = '{"token": "a2vpnh9u93ugkct7un4rs8x82c67x5", "user": "unv9n3e4qzd5bu3pp52tkfeoe4vfzu", "message": "' + args["torrent_name"] + ' has finished downloading."}'
    data = json.dumps(data, indent=4)
    print(data)

    test = requests.post('http://api.pushover.net/1/messages.json',
                         data='{"token": "a2vpnh9u93ugkct7un4rs8x82c67x5", "user": "unv9n3e4qzd5bu3pp52tkfeoe4vfzu", "message": "' + args["torrent_name"] + ' has finished downloading."}', 
                         headers={'content-type': 'application/json'})

    print(test.status_code)
main()
