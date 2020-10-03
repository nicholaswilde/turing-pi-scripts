# Turing Pi Scripts
Miscellaneous scripts for my [Turing Pi](https://turingpi.com/) setup. Turn on and off all nodes with a command or power button and have a power LED.

<p align="center"><img src="https://github.com/nicholaswilde/turing-pi-scripts/raw/develop/images/turing-pi.jpg" width="600"></p>

| :warning: **WARNING**:The register which controls the power to each board is backed by an EEPROM. Don't set all bits in there to 0, otherwise you won't be able to boot and correct it. A fix is to set register 0xF4 to 1 which would send the writes to the shadow SRAM, instead of the EEPROM. A fix for this is to connect an external raspberry pi to the I2C External pins and reset the registers. |
| :-- |

| Script | Function |
| --- | --- |
| `turn-on-nodes.sh` | Turns all nodes on via the CMB |
| `turn-off-nodes.sh` | Turns off all nodes via the CMB |
| `turn-on-nodes.service` | systemd service file to run turn-on-nodes.sh at boot |
| `listen-for-shutdown.py` | Listen for when the power button is held for 2 seconds and turn off the Turing Pi |
| `listen-for-shutdown.service` | systemd service file to start listen-for-shutdown.py at boot |

## Notes
- The power LED will blink a few times when holding the power button down for two seconds. All worker nodes will turn off first and a normal shutdown node will be ran on the master node.
- The power LED will stay on until the master node shuts down completely. 
- Once the power LED turns off, the power button can then be pressed to turn on the master node which will then turn on the worker nodes.

## Prerequisites
```bash
# turn-on-nodes.sh and turn-off-nodes.sh
$ sudo apt-get update
$ sudo apt-get install i2c-tools

# listen-for-shutdown.py
$ sudo apt-get install python3
$ sudo apt-get install python3-gpiozero
```

## Installation
On your master node:
```bash
$ cd ~
$ mkdir git
$ cd git
$ git clone https://github.com/nicholaswilde/turing-pi-scripts.git
$ cd turing-pi-scripts
$ chmod +x turn-on-nodes.sh
$ chmod +x turn-off-nodes.sh
$ chmod +x listen-for-shutdown.py
$ nano nodes.cfg
```
Edit the [I2C CMB registers](https://docs.turingpi.com/turing_pi/children/i2c_cluster_bus/#power-management) of the worker nodes in `nodes.cfg`.
```bash
# Node #1 (Master)
#0x02
# Node #2 (Worker 1)
0x04
# Node #3 (Worker 2)
0x08
# Node #4 (Worker 3)
0x10
# Node #5 (Worker 4)
0x80
# Node #6 (Worker 5)
0x40
# Node #7 (Worker 6)
0x20
```

Edit the `listen-for-shutdown.py` file and change the constants to your liking
```python
...
# Power button GPIO pin number (actual, not GPIO)
PIN_NO_BUTTON = 18
# Power LED pin number (GPIO, not actual)
PIN_NO_LED = 17
# Button hold time (s)
HOLD_TIME = 2
# Sleep time between power LED blinks (s)
SLEEP_TIME = 0.5
# Path to turn-off-nodes.sh
SCRIPT_PATH='/home/pirate/git/turing-pi-scripts/turn-off-nodes.sh'
...
```
[Turn on the power LED connected to GPIO 17 at boot](https://www.raspberrypi.org/documentation/configuration/config-txt/gpio.md) when the master node is on.

```bash
#/boot/config.txt
...
# Set GPIO17 to be an output set to 1
gpio=17=op,dh
...
```

### Optional
You can also copy the scripts to the bin folder to easily run them from anywhere
```bash
$ sudo cp turn-on-nodes.sh /usr/bin/turn-on-nodes
$ sudo cp turn-off-nodes.sh /usr/bin/turn-off-nodes
$ sudo cp listen-for-shutdown.py /usr/bin/listen-for-shutdown
# Copy the config file to the home folder
$ cp nodes.cfg ~/.config/
# Note: adding the config file to the home folder currently doesn't work with listen-for-shutdown.py
```

### Enable at boot
Edit `turn-on-nodes.service` file with the installation location of the `turn-on-nodes.sh` script.
```bash
...
ExecStart=/usr/bin/sudo /bin/bash -lc '/home/pirate/git/turing-pi-scripts/turn-on-nodes.sh'
...
```
Edit `listen-for-shutdown.service` file with the installation location of the `listen-for-shutdown.py` script.
```bash
...
ExecStart=/usr/bin/python3 /home/pirate/git/turing-pi-scripts/listen-for-shutdown.py
ExecStop=pkill -f /home/pirate/git/turing-pi-scripts/listen-for-shutdown.py
WorkingDirectory=/home/pirate/git/turing-pi-scripts/
...
```
```bash
# Copy the file
sudo cp turn-on-nodes.service /etc/systemd/system/turn-on-nodes.service
sudo cp turn-on-nodes.service /etc/systemd/system/listen-for-shutdown.service

# Change the permission of the files
$ sudo chmod 664 /etc/systemd/system/turn-on-nodes.service
$ sudo chmod 664 /etc/systemd/system/listen-for-shutdown.service

# Enable it at start
# sudo systemctl daemon-reload
$ sudo systemctl enable /etc/systemd/system/turn-on-nodes.service
$ sudo systemctl enable /etc/systemd/system/listen-for-shutdown.service
```

## Usage
```bash
# Turn on all worker nodes
$ sudo ./turn-on-nodes.sh
# or
$ sudo turn-on-nodes

# Turn off all worker nodes
$ sudo ./turn-off-nodes.sh
# or
$ sudo turn-off-nodes

# Start listen-for-shutdown.py
$ sudo ./listen-for-shutdown.py
# or
$ sudo listen-for-shutdown
# Hold the power button for two seconds and wait for the power LED to blink
```

## Wiring Diagram
<p align="center"><img src="https://github.com/nicholaswilde/turing-pi-scripts/raw/develop/images/pinout.png">
<br>
  <em>Image created with <a href="https://www.circuit-diagram.org/">Circuit Diagram</a></em>
</p>

## Todo
- [ ] Verify that the node register values are valid.
- [ ] Create install and uninstall scripts and/or deb package.
- [ ] Move `nodes.cfg` to `/etc/turing-pi-scripts/` directory.

## Credit
`listen-for-shutdown` is based off of [lihak's](https://github.com/lihak) [rpi-power-button](https://github.com/lihak/rpi-power-button)

## Author
The repository was created in 2020 by Nicholas Wilde.
