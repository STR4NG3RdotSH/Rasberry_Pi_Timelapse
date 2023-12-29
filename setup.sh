#!/bin/bash

# Create timelapse.sh
cat > /home/pi/timelapse.sh <<\EOF
#!/bin/bash
date=$(/usr/bin/date '+%d.%b.%Y %T' | /usr/bin/sed 's/ /./' | /usr/bin/sed 's/:/./' | /usr/bin/sed 's/:/./' | /usr/bin/sed 's/-/./' | /usr/bin/sed 's/-/./' | /usr/bin/sed 's/-/./')        
fswebcam -d /dev/video0 --no-banner -r 3264x2448 -S 240 /home/pi/share/images/$date.jpg
EOF
chmod +x /home/pi/timelapse.sh

# Create buildvideo.sh
cat > /home/pi/buildvideo.sh <<\EOF
#!/bin/bash
vidname=vid_$(/usr/bin/date '+%d.%b.%Y %T' | /usr/bin/sed 's/ /./' | /usr/bin/sed 's/:/./' | /usr/bin/sed 's/:/./' | /usr/bin/sed 's/-/./' | /usr/bin/sed 's/-/./' | /usr/bin/sed 's/-/./')
mencoder "mf:///home/pi/share/images/*.jpg" -mf fps=25:type=jpg -ovc lavc -lavcopts vcodec=mpeg4:mbd=2:trell:vbitrate=16000 -vf scale=3264:2448 -oac copy -o /home/pi/share/videos/$vidname.mp4
rm /home/pi/share/images/*.jpg
reboot
EOF
chmod +x /home/pi/buildvideo.sh

# Make image/video folders
mkdir share /home/pi/share/images /home/pi/share/videos

#Set folder permissions
chmod -R 777 share/

# Install required packages
apt update -y
apt install fswebcam samba samba-common-bin mencoder -y

# Update samba config
cat >>/etc/samba/smb.conf << EOL
[timelapse]
path = /home/pi/share
writeable=Yes
create mask=0777
directory mask=0777
public=yes
EOL

# Restart samba
sudo systemctl restart smbd

# Create cron jobs for image capture and video compiling
echo "* 5-21 * * * root /home/pi/timelapse.sh" > /etc/cron.d/timelapse
echo "1 0 * * * root /home/pi/buildvideo.sh" > /etc/cron.d/buildvideo
