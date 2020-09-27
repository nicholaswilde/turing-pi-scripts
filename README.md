# Turing Pi Scripts
Miscellaneous scripts for my [Turing Pi](https://turingpi.com/) setup.

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
Do the same for `turn-off-nodes.sh`
### Optional
You can also copy the scripts to the bin folder to easily run them from anywhere
```bash
$ sudo cp turn-on-nodes.sh /usr/bin/turn-on-nodes
$ sudo cp turn-off-nodes.sh /usr/bin/turn-off-nodes
# Copy the home folder
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
$ ./turn-on-nodes.sh

# Turn off all worker nodes
$ ./turn-off-nodes.sh
```
