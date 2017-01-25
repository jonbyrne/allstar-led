import RPi.GPIO as GPIO
import time
import os

#adjust for where your switch is connected
buttonPin = 24
GPIO.setmode(GPIO.BCM)
GPIO.setup(buttonPin,GPIO.IN)

while True:
  #assuming the script to call is long enough we can ignore bouncing
  if (GPIO.input(buttonPin)):
    #this is the script that will be called (as root)
    time.sleep(0.05)
    os.system("/usr/sbin/asterisk  -rx 'rpt fun 40890 *327066'")
    print("Connecting.....")
