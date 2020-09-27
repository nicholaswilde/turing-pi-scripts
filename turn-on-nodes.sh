#!/bin/bash

# 0x02 : Node #1 (Master)
# 0x04 : Node #2 (Worker 1)
# 0x08 : Node #3 (Worker 2)
# 0x10 : Node #4 (Worker 3)
# 0x80 : Node #5 (Worker 4)
# 0x40 : Node #6 (Worker 5)
# 0x20 : Node #7 (Worker 6)

sudo i2cset -m 0x04 -y 1 0x57 0xf2 0x00
sleep 2
sudo i2cset -m 0x04 -y 1 0x57 0xf2 0xff
sleep 2
sudo i2cset -m 0x08 -y 1 0x57 0xf2 0x00
sleep 2
sudo i2cset -m 0x08 -y 1 0x57 0xf2 0xff
sleep 2
sudo i2cset -m 0x10 -y 1 0x57 0xf2 0x00
sleep 2
sudo i2cset -m 0x10 -y 1 0x57 0xf2 0xff
sleep 2
sudo i2cset -m 0x80 -y 1 0x57 0xf2 0x00
sleep 2
sudo i2cset -m 0x80 -y 1 0x57 0xf2 0xff
sleep 2
sudo i2cset -m 0x40 -y 1 0x57 0xf2 0x00
sleep 2
sudo i2cset -m 0x40 -y 1 0x57 0xf2 0xff
sleep 2
sudo i2cset -m 0x20 -y 1 0x57 0xf2 0x00
sleep 2
sudo i2cset -m 0x20 -y 1 0x57 0xf2 0xff


