#!/bin/bash

DIFF=$(diff /etc/crontab.monit /etc/crontab)
if [ "$DIFF" != "" ]; then
        echo "Crontab modified, notifying root by email." | mail -s "Crontab modified" root
fi
cp /etc/crontab /etc/crontab.monit
