# allstar-led
Raspberry Pi app_rpt LED and Button Tools

Ghetton circuit diagram https://github.com/jonbyrne/allstar-led/blob/master/IMG_20170125_213357.jpg


run the following commands

apt-get install git
cd ~/
git clone https://github.com/jonbyrne/allstar-led
mkdir /etc/asterisk/local/
cd allstar-led
mv *.* /etc/asterisk/local/
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


