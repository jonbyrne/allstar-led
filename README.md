# allstar-led
Raspberry Pi app_rpt LED and Button Tools

best viewed in raw https://raw.githubusercontent.com/jonbyrne/allstar-led/master/README.md

Ghetto circuit diagram https://github.com/jonbyrne/allstar-led/blob/master/IMG_20170125_213357.jpg


run the following commands

##### Raspbian Based Build #######
apt-get install git
##################################

##### Arch Based Build ###########

pacman -S
useradd -m -G wheel -s /bin/bash pi
passwd pi
>>>>enter password and confirm
visudo
>>>>>uncomment line adding all wheel group to sudo by removing the #
ctrl + x
y
enter
exit

reconnect as pi user you have created then

git clone https://aur.archlinux.org/python-raspberry-gpio.git
cd python-raspberry-gpio/
pacman -S fakeroot
makepkg -si
exit

reconnect as root
##################################

cd ~/
git clone https://github.com/jonbyrne/allstar-led
mkdir /etc/asterisk/local/
cd allstar-led
mv *.* /etc/asterisk/local/
chmod +x /etc/asterisk/local/check2.sh
chmod +x /etc/asterisk/local/check_default.sh
crontab -e

##################
Then scroll to the last line and paste the follwing lines replacing XXXXX with your node and YYYYY with the node you wish to check the connection to.
##################

* * * * * sh /etc/asterisk/local/check2.sh
* * * * * /etc/asterisk/local/check_default.sh xxxxx yyyyy 27

##################
Then press crtl + x
then "y"
then enter

run the following command

nano /etc/asterisk/local/button1.py

in the file just opened edit XXXXX to your node and YYYYY to the node you wish the button to connect to, both are on the last line.

Then press crtl + x
then "y"
then enter

Finally run
nano /etc/rc.local

paste the following line after the line that states "# By default this script does nothing."


#######################
python /etc/asterisk/local/button1.py
#######################

Then press crtl + x
then "y"
then enter
reboot


