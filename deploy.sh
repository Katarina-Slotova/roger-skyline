#!/bin/bash
DIFF=$(diff /var/www/html/index.nginx-debian.html /var/www/backup/index.backup.html)
if [ "$DIFF" != "" ]; then
    cat /var/www/html/index.nginx-debian.html > /var/www/backup/index.backup.html
    sudo cp /var/www/backup/index.backup.html /var/www/html/index.nginx-debian.html
    echo "Website modified, creating backup of index.html..."
    echo "Backup created, deploying now..."
    echo "Deployment done!"
fi
