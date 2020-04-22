#!/bin/bash

#Everything here is set up for one device at a time. to do multiple devices one after another, 
# I just ran the script in a while loop at the command line:    while (true); do ./InstallAPKs.sh; done
#There are ways to do this with more than one device connected, but being I'll be manually interacting, 
# it would've been a little complicated to interact with

#If you get "Permission Denied" from the shell, do: chmod +x InstallAPKs.sh

#You will also need to tell your device to "Use to transfer files" from the dropdown. 
#Next, approve your computer from your device with the pop-up window

echo "Waiting for device....."
adb wait-for-device
adb devices

#this just sets font to bold so i can recognize the darker lines without looking at them.
setterm -bold on

#These tablets come with lock screen "Promotions" (advertisements) that you have to pay $15 or contact amazon to remove. 
#This is an alternative, so patients don't have to see advertisements for candy crush 
# or temple run every time they turn on the device.
#You don't need to do this, but I feel guilty not considering where these will be going. 
echo "Setting lock screen_ad_enabled"
adb shell settings put global LOCKSCREEN_AD_ENABLED 0


#This simply turns of screen animations. It saves very small moment of your time, but I get impatient just seeing them.  
echo "Removing transition scale, because why not.."
adb shell settings put global animator_duration_scale 0.0
adb shell settings put global transition_animation_scale 0.0
adb shell settings put global window_animation_scale 0.0



#The hospital these tablets were going to required a lock screen.
#This opens that menu setting up so you don't have to manually navigate there. 
echo "Open Lock screen to change pin. You do that...."
adb shell am start -a android.settings.SECURITY_SETTINGS

#now it's time to install all the apps in the current directory. 
#  Here's a list of the apps I installed:
#
#  com.android.chrome.apk
#  com.android.vending.apk
#  com.facebook.orca.apk
#  com.google.android.apps.tachyon.apk
#  com.google.android.gms.apk
#  com.google.android.gsf.apk
#  com.google.android.gsf.login.apk
#  com.instagram.android.apk
#  com.skype.raider.apk
#  com.whatsapp.apk
#  us.zoom.videomeetings.apk

#The for loop lists all apps in the current directory, and installs them one by one.
echo "Installing apps in current directory.."
echo

setterm -bold off

for i in $(ls *.apk); 
	 do
         echo "Installing $i"
	     adb install $i;
	 done


#open website so it's the first thing when chrome is opened. May ask you to choose default browser.
adb shell am start -a android.intent.action.VIEW -d http://tabs4covid.com/

echo
setterm -bold on
echo "Done installing Apps."
echo

#Last I checked, a reboot is required for LOCKSCREEN_AD_ENABLED to take effect.
#This may not be required, but seeing the splash screen on reboot
# let me know without looking when it was time to move on to the next device. 
echo "Reboot now for lockscreen changes to effect...."
adb shell reboot now
