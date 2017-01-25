#!/bin/bash

#set -x

#
# Variables Section
#==============================================================
# list process to monitor in the variable below.

PROGRAM1=”asterisk”

# varible checks to see if $PROGRAM1
# is running.

APPCHK=$(ps -d -N | grep -c "asterisk")

#
#
# $Company & $SITE variables are for populating the alert email
# $SUPPORTSTAFF is the recipient of our alert email

#==================================================================

# The ‘if’ statement below checks to see if the process is running
# with the ‘ps’ command.  If the value is returned as a ‘0’ then


if [ $APPCHK = 1 ];

then

python /etc/asterisk/local/ledon.py

else

python /etc/asterisk/local/ledoff.py

fi

echo $APPCHK

exit
