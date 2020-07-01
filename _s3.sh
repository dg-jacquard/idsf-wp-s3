#!/bin/bash
# Uploading backup to S3 in Bash
# Coded by Diogo Nechtan <dnechtan@gmail.com>
# Run it as root
# chmod +x s3.sh
# ./s3.sh
# crontab example:
# sudo su
# crontab -e
# 1 3 * * * /var/www/s3.sh

# <S3.Config>
s3Key=AKIAUPAU2HHA7DBM6JNH
s3Secret=kxU9hrrDlQ5repoMPABNmjsyVTS3woQaRiD0BISX
bucket=idsf-backup
# </S3.Config>

backFile=backup_$(date +%d-%m-%Y_%H-%M).zip #format: DD/MM/YYYY HH:MM
cd /root/wp_upgrade # backup folder
zip -r ../${backFile} * # zip folder
sleep 2
echo
echo ███████ ███████ SENDING TO AMAZON S3 ███████ ███████ 
echo
sleep 2
file=../${backFile}
resource="/${bucket}/${backFile}"
contentType="application/x-zip-compressed" #mimetype
dateValue=`date -R`
stringToSign="PUT\n\n${contentType}\n${dateValue}\n${resource}"
signature=`echo -en ${stringToSign} | openssl sha1 -hmac ${s3Secret} -binary | base64`
curl -v -i -X PUT -T "${file}" \
          -H "Host: ${bucket}.s3.amazonaws.com" \
          -H "Date: ${dateValue}" \
          -H "Content-Type: ${contentType}" \
          -H "Authorization: AWS ${s3Key}:${signature}" \
          https://${bucket}.s3.amazonaws.com/${backFile}
sleep 1
echo Removing local backup...
rm ${file}

cat << "EOF"

██ ██████  ███████ ███████ 
██ ██   ██ ██      ██      
██ ██   ██ ███████ █████ 
██ ██   ██      ██ ██    
██ ██████  ███████ ██ 
backup 1.0.0



██ ██ ██ ██ Backup OK


EOF

echo *RESULT* https://${bucket}.s3.amazonaws.com/${backFile}
echo $(date -R)
echo 
