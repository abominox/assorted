#!/usr/bin/python3
# Bi-daily check of homelab services

import requests, os, datetime
from pushbullet import Pushbullet

services_dict = {
    # HTPC
    'Plex': 'http://192.168.1.3:32400/web/index.html',
    'Sonarr': 'http://192.168.1.3:8989/',
    'Radarr': 'http://192.168.1.3:7878/',
    'Lidarr': 'http://192.168.1.3:8686/',
    'Jackett:': 'http://192.168.1.3:9117/UI/Dashboard',
    'Ombi': 'http://192.168.1.3:3579/login',
    'qBittorrent': 'http://192.168.1.50:8080/',
    # Minecraft
    'MC Server Admin Panel': 'http://192.168.1.151:8081/',
    # Misc
    'Personal Website': 'http://cjmarquart.com',
    'FreeNAS': 'http://192.168.1.65/ui/sessions/signin',
    'Splunk': 'http://192.168.1.200:8000/en-US/app/launcher/home',
    'NAS': 'http://192.168.1.12:8080/cgi-bin/'
}

check_mark = u"\u2705"
x_mark = u"\u274C"

time = datetime.datetime.now()

pb = Pushbullet(os.getenv('pb_key'))

def main():
    report_string = 'Service Report for ' + time.strftime("%b %d %Y") + '\n'

    for key, value in services_dict.items():
        report_string += test_service(key, value)
    pb.push_note('', report_string)

def test_service(service_name, service_address):
    response = requests.get(service_address)
    if response.status_code == 200:
        return service_name + '  [' + check_mark + ']\n'
    else:
        return service_name + '  [' + x_mark + ']\n'

main()