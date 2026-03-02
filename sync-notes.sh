#!/bin/bash

LOGFILE=~/rsync-notes.log

echo "Sync started $(date)" >> $LOGFILE

/usr/bin/rsync -avzu --delete \
-e "/usr/bin/ssh -i /home/nuznhy/.ssh/id_home_server -o IdentitiesOnly=yes" \
nuznhy@home.server:~/notes/ ~/notes/ >> $LOGFILE 2>&1

/usr/bin/rsync -avzu --delete \
-e "/usr/bin/ssh -i /home/nuznhy/.ssh/id_home_server -o IdentitiesOnly=yes" \
~/notes/ nuznhy@home.server:~/notes/ >> $LOGFILE 2>&1


echo "Sync finished $(date)" >> $LOGFILE
