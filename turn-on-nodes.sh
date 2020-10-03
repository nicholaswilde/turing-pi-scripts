#!/bin/bash

file="nodes.cfg"
# Sleep time
time=2
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Check if run as sudo
if (( $EUID != 0 )); then
    echo "Not run as sudo"
    exit
fi

# Check if i2c-tools is installed
if ! command -v i2cset &> /dev/null; then
    echo "i2c-tools is not installed"
    exit 1
fi

# Check the ~/.config dir if file does not exist
if [ ! -f $DIR/$file ]; then
    file="$(eval echo ~${SUDO_USER})/.config/$file"
else
    file=$DIR/$file
fi

if [ ! -f $file ]; then
    echo "Missing file $file"
    exit 1
fi

while IFS= read -r line; do
    if [[ ! "$line" =~ ^#.*$ ]]; then
        echo "Processing $line"
        i2cset -m $line -y 1 0x57 0xf2 0x00
        sleep $time
        i2cset -m $line -y 1 0x57 0xf2 0xff
        sleep $time
    fi
done < "$file"
