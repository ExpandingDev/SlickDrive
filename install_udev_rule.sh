#!/bin/bash

# This script will install the SlickDrive udev rules into your udev config
# Should be run as root/sudo because it will be copying files into /etc/udev/rules.d/

source slick-drive.conf

selected_line=""
selected_vendor=""
selected_product=""

select_usb_device() {
	echo "Please select the drive from the following output from lsudb:"

IFS='
'
select o in $(lsusb) Exit; do
	case $o in
		Exit)
			exit 0
			break ;;
		*)
			selected_line=${o}
			break;;
	esac
done

selected_vendor=$( echo "$selected_line" | sed -e "s/.*\([0-9a-f]\{4\}\):\([0-9a-f]\{4\}\).*/\1/" )
selected_product=$( echo "$selected_line" | sed -e "s/.*\([0-9a-f]\{4\}\):\([0-9a-f]\{4\}\).*/\2/" )
echo "Vendor: ${selected_vendor}"
echo "Product: ${selected_product}"
}

echo "Installing udev rules for SlickDrive..."
if [ -d /etc/udev/rules.d ];
then
	echo "Found /etc/udev/rules.d/"
else
	echo "Could not find /etc/udev/rules.d ! Exiting!!!"
	exit -1
fi

if [ -f /etc/udev/rules.d/${UDEV_RULES_FILE} ]; then
	echo "Error! Found previous rules /etc/udev/rules.d/${UDEV_RULES_FILE}! Please remove this or specify a different install location for the SlickDrive udev rules!"
	exit -2
fi

select_usb_device
echo ${SCRIPT_PATH}

cat >temp.rules <<EOL
SUBSYSTEM=="block", ACTION=="add", ATTRS{idVendor}=="${selected_vendor}", ATTRS{idProduct}=="${selected_product}", RUN+="${SCRIPT_PATH}"
EOL
cp -v temp.rules /etc/udev/rules.d/${UDEV_RULES_FILE}

echo "Reloading udev rules..."
udevadm control --reload-rules

echo "DONE"

