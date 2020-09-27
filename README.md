# Turing Pi Scripts
Miscellaneous scripts for my [Turing Pi](https://turingpi.com/) setup.

| :warning: **WARNING**:The register which controls the power to each board is backed by an EEPROM. Don't set all bits in there to 0, otherwise you won't be able to boot and correct it. A fix is to set register 0xF4 to 1 which would send the writes to the shadow SRAM, instead of the EEPROM. A fix for this is to connect an external raspberry pi to the I2C External pins and reset the registers. |
| :-- |

| Script | Function |
| --- | --- |
| `turn-on-nodes.sh` | Turns all nodes on via the CMB |
| `turn-off-nodes.sh` | Turns off all nodes via the CMB |
| `turn-on-nodes.service` | systemd service file to run turn-on-nodes.sh at boot |

## Prerequisites
```bash
$ sudo apt-get update
$ sudo apt-get install i2c-tools
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
### Optional
You can also copy the scripts to the bin folder to easily run them from anywhere
```bash
$ sudo cp turn-on-nodes.sh /usr/bin/turn-on-nodes
$ sudo cp turn-off-nodes.sh /usr/bin/turn-off-nodes
# Copy the config file to the home folder
$ cp nodes.cfg ~/.config/
```

### Enable at boot
Edit `turn-on-nodes.service` file with the installation location of the `turn-on-nodes.sh` script.
```bash
...
ExecStart=/bin/bash /home/pirate/git/turing-pi-scripts/turn-on-nodes.sh
...
```
```bash
# Copy the file
sudo cp turn-on-nodes.service /etc/systemd/system/turn-on-nodes.service

# Change the permission of the file
$ sudo chmod 664 /etc/systemd/system/turn-on-nodes.service

# Enable it at start
$ sudo systemctl enable /etc/systemd/system/turn-on-nodes.service
```

## Usage
```bash
# Turn on all worker nodes
$ sudo ./turn-on-nodes.sh
# or
# sudo turn-on-nodes

# Turn off all worker nodes
$ sudo ./turn-off-nodes.sh
# or
$ sudo turn-off-nodes
```

## Todo
- [ ] Verify that the node register values are valid.
