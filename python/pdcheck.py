#!/home/filipefelisbino/.xmonad/python/venv/bin/python3

import pypd
from pprint import pprint
import json
from os.path import expanduser

pdconf = json.load(open(expanduser('~/.config/pd.conf')))
pypd.api_key = pdconf['api_key']

# fetch some data
incidents = pypd.Incident.find(statuses=['triggered', 'acknowledged'])
statuses = set([incident.get('status') for incident in incidents])

if 'triggered' in statuses:
    print("triggered")
elif 'acknowledged' in statuses:
    print("acknowledged")
else:
    print("ok")
