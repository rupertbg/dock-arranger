#!/bin/bash

#### REQUIRES dockutil (https://github.com/kcrawford/dockutil) ####

dockutil=/usr/local/dockutil

 ###################################################################
 ##                           App Names                           ##
 ###################################################################

 ## Apps are searched using these arrays as strings with wildcard ##
 ## characters either side and the .app extension on the end,     ##
 ## down two directory levels.                                    ##

 ## Some customisations have been made for apps with different    ##
 ## directories in the application search section on line 45.     ##

 ## Apple apps and other removals, if any, are done using the     ##
 ## name of the  application only and no [.app] is added by this  ##
 ## script.                                                       ##

 ###################################################################

appleremove=("Photos" "Pages" "Numbers" "Keynote" "GarageBand" "Maps" "FaceTime" "Messages" "iTunes" "Reminders" "Notes" "System Preferences")

browsers=("Google Chrome" "Firefox")

office=("Microsoft Word" "Microsoft Excel" "Microsoft PowerPoint" "Microsoft OneNote" "Microsoft Outlook")

adobe=("Adobe Acrobat DC" "Adobe Acrobat Pro" "Adobe Photoshop" "Adobe Illustrator" "Adobe InDesign" "Adobe Premiere")

apps=("Managed Software Center" "VirtualBox" "VMWare" "MATLAB" "SPSSStatistics" "Prism" "NVivo" "Papers" "FileMaker")

admin=("Managed Software Center" "Terminal" "Disk Utility" "TextWrangler" "Directory Utility" "Network Utility" "System Preferences")

adminremove=("Mail" "Contacts" "Calendar" "iBooks")

 ###################################################################

 ###################################################################

## Checks for a file to ensure script runs only on first login

if [ ! -f ~/.userconfig ]
then

 ###################################################################
 ##                     Application Search                        ##
 ###################################################################

 ## The arrays above are used below to search for applications    ##
 ## that contain the names entered. Each array element is run     ##
 ## through a find command and added to another, new, array.      ##

 ## You'll notice some apps have conditional statements that run  ##
 ## a modified path or argument into the find for specific        ##
 ## application requirements.                                     ##

 ###################################################################

## Stops path strings with spaces from entering an array as multiple entries. (e.g. stops "/path/to this/place" becoming "/path/to" "this/place" in the array)

IFS=$'\t\n'

## Enters names from the arrays above into a find command and appends the output paths to a new array

for i in "${browsers[@]}"; do
browserpaths+=( $(find /Applications -maxdepth 2 -type d -iname "*$i*[.app]" ) )
done

for j in "${office[@]}"; do
apppaths+=( $(find /Applications -maxdepth 2 -type d -iname "*$j*[.app]" ) )
done

for k in "${adobe[@]}"; do
apppaths+=( $(find /Applications -maxdepth 2 -type d -iname "*$k*[.app]" ) )
done

for l in "${apps[@]}"; do
if [ "$l" == "SPSSStatistics" ]
then
## SPSS lives in strange places like IBM/Statistics/SPSS/22/
apppaths+=( $(find /Applications -maxdepth 6 -type d -iname "*$l*[.app]" ) )
else
apppaths+=( $(find /Applications -maxdepth 2 -type d -iname "*$l*[.app]" ) )
fi
done

for m in "${admin[@]}"; do
if [ "$m" == "Network Utility" ] || [ "$m" == "Directory Utility" ]
then
## DU and NU live in a system folder
adminpaths+=( $(find /System/Library/CoreServices/Applications -type d -iname "*$m*[.app]" ) )
else
adminpaths+=( $(find /Applications -maxdepth 2 -type d -iname "*$m*[.app]" ) )
fi
done

 ###################################################################

 ###################################################################

## Notifies user of configuration

osascript -e 'display notification "Please wait" with title "Configuring User Profile" subtitle "The screen may flash a few times"'

sleep 2

 ###################################################################
 ##                     Dock Configurator                         ##
 ###################################################################

for ((n=0;n<2;n++)) ## runs twice for consistency
do

if [ $HOME = "/Users/ADMINACCOUNT" ]
then

## configures an admin account dock (for enterprise use)

for removal in "${appleremove[@]}"; do
$dockutil --remove ${removal} --no-restart
done

for adminremoval in "${adminremove[@]}"; do
$dockutil --remove ${adminremoval} --no-restart
done

for browser in "${browserpaths[@]}"; do
$dockutil --add ${browser} --after Safari --no-restart
done

for adminapp in "${adminpaths[@]}"; do
if [[ "$adminapp" == *"Managed Software Center"* ]]
then
$dockutil --add ${adminapp} --position beginning --no-restart
else
$dockutil --add ${adminapp} --position end --no-restart
fi
done

defaults write com.apple.dock persistent-others -array-add '{"tile-data" = {"list-type" = 1;}; "tile-type" = "recents-tile";}'

else

## configures non-admin user account dock

for removal in "${appleremove[@]}"; do
$dockutil --remove ${removal} --no-restart
done

for browser in "${browserpaths[@]}"; do
$dockutil --add ${browser} --after Safari --no-restart
done

for app in "${apppaths[@]}"; do
if [[ "$app" == *"Managed Software Center"* ]]
then
$dockutil --add ${app} --position beginning --no-restart
else
$dockutil --add ${app} --position end --no-restart
fi
done

fi

done

sleep 2

Killall -kill Dock

 ###################################################################

 ###################################################################

sleep 2

## Leaves a file to prevent the script running again

touch ~/.userconfig

## Notifies user of config completion

osascript -e 'display notification "Thank you for your patience" with title "Configuration Complete!" subtitle "You can continue using your machine"'

fi

exit 0
