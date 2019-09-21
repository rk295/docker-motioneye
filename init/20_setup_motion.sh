#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

if [ ! -d /home/nobody/motioneye/conf ]; then
        mkdir -p /home/nobody/motioneye/{conf,log,run,media}
        chown -R nobody:users /home/nobody
        chmod -R 775 /home/nobody
        ln -sf /config/motion.conf /home/nobody/motioneye/conf/motion.conf
        ln -sf /config/motioneye.conf /home/nobody/motioneye/conf/motioneye.conf
fi

# Fix settings in motion and motioneye
sed -i '/conf_path.*/c\conf_path /config' /config/motioneye.conf

# Set permissions on the config directory
echo "Fixing permissions"
chown -R nobody:users /config /home/nobody/motioneye/media
chmod -R 775 /config
