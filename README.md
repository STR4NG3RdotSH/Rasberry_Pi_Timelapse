# Summary
This script sets up a timelapse camera on your Rasberry Pi. Simply download setup.sh to your home folder or clone this repo to your home folder, then run setup.sh

# What exactly does the script do?
- Create timelapse.sh (The script that will take periodic photos)
- Create buildvideo.sh (The script that will combine those photos into a video every night)
- Make image/video folders (For storing resulting photos/videos)
- Install required packages (fswebcam [photo capture], samba & libs [to allow you to view photos/videos over your network], mencoder [video creation])
- Update samba config to allow you to access photos/videos over network
- Restart samba service
- Create cron jobs for image capture and video compiling

# Bugs?
None yet, although I've only run this on Pi's that are dedicated to the task at hand (Only running the timelapse stuff), so no idea how it will perform if you have a bunch of other stuff/tasks going on with your pi.

# What Pi's can this run on?
I've had it running on Pi3, Pi4, PiZeroW, PiZero2W, OrangePiZero2W. The Pi4 has been capturing its photos every 15 seconds for about 5 months without issue, while the rest have all been set to 60 seconds. No issues on any, yet.

# How much storage space does this use? How long can I let this capture for?
Its highly dependent on the resolution you capture at (The script is set to 3254x2448). On one of mine right now, thats the resolution I've got it set to, and its capturing one image every 60 seconds. Each image varies in size from about 3.5 to 5.5mb. There are 1440 minutes in a day, so if we say 1440 images at 6mb each that would equate to about 8.6gb per day for images, BUT, after compiling its nightly video, it deletes all those images and the next day's captures start with a clean slate. Each video comes up to about 350-400mb. So a year of videos would take up about 146gb. 

# Usage 
The setup script makes 2 assumptions, that your user folder is /home/pi and your video device is /dev/video0 (Most systems default the first plugged in video device to this). You may have to tweak the script if either of these don't match your needs. Everything else should work perfectly on all PiOS (And most linux distros, tbh)
- Once you have the setup.sh script downloaded/cloned, change it if needed (See above comment about user folder and video device)
- Run setup.sh
How to confirm its working:
- Check if the smbd service is running (`service smbd status`)
- Check if images are appearing in `/home/pi/share/images` (../videos will start populating after midnight as it compiles every night)
- Check if the network share is alive from windows by opening the file explorer and entering this into the address bar: `\\<your_pi_name_or_ip>\timelapse\`

***NOTE: Over the years I've noticed Rasberry Pi's like to just drop off the Wifi once in a while. Since the photos/videos are saved locally, this won't affect your timelapse, so you can truly set and forget. I notice I can't SSH to them sometimes, or the network share is down, a simple reboot fixes it and the photos/videos have always just continued capturing regardless.
