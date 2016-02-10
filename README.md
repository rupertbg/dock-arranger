# dock-arranger.sh
### A bash script to easily define osx dock apps (at login if paired with a LaunchAgent). 

Written as a run-once. Leaves .userconfig in the users home to prevent the script running again if called by a LaunchAgent at login.

### Requirements

dockutil (https://github.com/kcrawford/dockutil) must be located in /usr/local/ or variable in script edited to suit
OS X 10.11+ (Probably works on older version but haven't tested)

### Options

The first section is made up of arrays which you can use to input names of apps located in /Applications that you would like added to the dock.

The second section is made up of find commands in for loops that iterate through the arrays of names to produce arrays of full paths compatible with dockutil.
I have appended most name arrays into a single 'apppaths' array, however you could keep them separate by naming the output arrays differently. The reason you would do this brings us to the next section. There is also an example of picking individual elements from the arrays using conditions.

The third section is made up of dockutil commands in for loops that iterate through the path arrays and add/remove apps in the dock based on the options provided by dockutil. If you have separately named path arrays coming in then you have the ability to make each array end up in a different place in the dock etc. I have also included examples of individually selecting an item in the array using conditions.
