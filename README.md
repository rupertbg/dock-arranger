# dock-arranger.sh
### A bash script to find apps and edit placement in the osx dock 

Written as a run-once - leaves .userconfig in the users home to prevent the script running again. Designed for use with a LaunchAgent to run at login.

### Requirements

- dockutil (https://github.com/kcrawford/dockutil) must be located in /usr/local/ or variable in script edited to suit

- OS X 10.11.x (Probably works on older versions but haven't tested)

### Options

The dock-arranger script is made up of three main sections:

#### 1. App name arrays
The first section is made up of arrays which you can use to input names of apps located in /Applications that you would like added to the dock.

#### 2. Application searching
The second section is made up of find commands in for loops that iterate through the arrays of names to produce arrays of full paths compatible with dockutil.

Application names are passed through find as \*Google Chrome\*.app so applications that have versions on the end or a company prefix are still picked up. E.g. putting "Photoshop" in an app name array will be searched as \*Photoshop\*.app and throw out results like /Applications/Adobe Photoshop CC 2015/Adobe Photoshop CC 2015.app

The script is written to take the least amount of time. Most applications are found within 2 directory levels of /Applications, so most app names are passed through with find -maxdepth 2. Some applications will need different -maxdepths set or sometimes completely different paths. To speed things up I use if statements to filter out the other apps from being searched at higher -maxdepth or from a folder further up the hierarchy than necessary.

For my purposes most of the name arrays filter into a single 'apppaths' array, however you could keep them separate by naming the output arrays differently. The reason you would do this is mentioned in the next section.

#### 3. Configuration using dockutil 
The third section is made up of dockutil commands in for loops that iterate through the path arrays and add/remove apps in the dock based on the options provided by dockutil. If you have separately named path arrays coming in then you have the ability to make each array end up in a different place in the dock etc. I have also included examples of individually selecting an item in the array using conditions.
