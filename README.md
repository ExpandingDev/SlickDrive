# Slick Drive
A simple Bash script that allows the user to select a currently inserted USB drive and specify a script to run when the drive is inserted.

# Usage
Before running `install_udev_rules.sh`, please adjust the variables found in `slick-drive.conf`. The most important variable is the `SCRIPT_PATH` variable that is the absolute path to the script that should be run when the drive is inserted.
Once you have the correct configuration, you can then run `install_udev_rules.sh` as sudo/root. The script will allow you to interactively select a currently plugged in USB device to generate the udev rules for.

# Uninstalling/removing
To remove the generated udev rules, just `sudo rm` the corrent `.rules` file in your `/etc/udev/rules.d` directory.

