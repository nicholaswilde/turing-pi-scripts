#!/usr/bin/env python

from gpiozero   import Button, LED
from signal     import pause
from time       import sleep
import os

# Power button pin number
PIN_NO_BUTTON = 18
# Power LED pin number
PIN_NO_LED = 17
# Button hold time
HOLD_TIME = 2
# Sleep time between power LED blinks
SLEEP_TIME = 0.5
# Path to turn-off-nodes.sh
SCRIPT_PATH='/home/pirate/git/turing-pi-scripts/turn-off-nodes.sh'

def longpress():
    print("Shutting down")
    if PIN_NO_LED:
        blink()
    os.system(SCRIPT_PATH)
    os.system('shutdown -h now')

def blink():
    led = LED(PIN_NO_LED)
    led.off()
    sleep(SLEEP_TIME)
    led.on()
    sleep(SLEEP_TIME)
    led.off()
    sleep(SLEEP_TIME)
    led.close()
    # Use brute force method because gpiozero turns off output on exit
    os.system('echo "' + str(PIN_NO_LED) + '" | tee /sys/class/gpio/export >/dev/null')
    os.system('echo "out" | tee /sys/class/gpio/gpio' + str(PIN_NO_LED) + '/direction >/dev/null')
    os.system('echo "1" | tee /sys/class/gpio/gpio' + str(PIN_NO_LED) + '/value >/dev/null')

def main():
    if not os.path.exists(SCRIPT_PATH):
        sys.exit('turn-off-nodes.sh file does not exist')
    button = Button(PIN_NO_BUTTON, hold_time=HOLD_TIME)
    button.when_held = longpress
    print("Staring listen-for-shutdown")
    pause()

if __name__ == "__main__":
    main()
