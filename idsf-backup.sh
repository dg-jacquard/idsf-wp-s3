#!/bin/bash
# Coded by Diogo Nechtan <dnechtan@gmail.com>
# Run it as root
# chmod +x idsf-backup.sh
# ./wordpress-backup.sh
# crontab example:
# sudo su
# crontab -e
# 10 3 * * * /root/idsf.sh

chmod +x s3.sh
chmod +x wp-backup.sh

if [ -e /tmp/wp.lock ];then
  rm /tmp/wp.lock
fi

cat << "EOF"

██ ██████  ███████ ███████ 
██ ██   ██ ██      ██      
██ ██   ██ ███████ █████ 
██ ██   ██      ██ ██    
██ ██████  ███████ ██ 
backup 1.0.0

EOF

sleep 3
bash _wp-backup.sh --path /var/www/wordpress
sleep 3
bash _s3.sh --path /var/www/wordpress
