#!/bin/bash

# Allstar script by Neil Mooney M0NFI

#

# Some code with thanks from scripts by Kyle Yoksh, K0KN

#

# V1.2 January 2016

#

#

# Revision History

# 

# V1.0 - Original

# V1.1 - Added do not disconnect list

# V1.2 - Set connection type to not permanent by default with option to change as script variable

#

#

# Check if node $1 is connected to node $2

# If $2 is not connect it will connect it

# Disconnects any nodes connected except $2

#

# Script is named check_default.sh

# Script is in directory /etc/asterisk/local/

# Log file reconnectlog is created in /var/log/asterisk/

#

# The following line can be changed at the top of the script to select the remote connection method. Default is non permanent

#

# PermanentLink=0		; Select if remote connection is permanent or not. 1 = Yes  0 = No

#

# 

# Called from rpt.conf using these settings

#

# Change XXXXX for your local node number

# Change YYYYY for the default remote node number

#

#

# [XXXXX]			; local node

#

# lnkactenable=1		; used to automatically link to default node after inactivity time

# lnkacttime=1200		; time in seconds of inactivity before running macro

# lnkactmacro=*59		; macro to run

#

# startup_macro = *59   	; Macro to run at startup for initial node connection

#

#

# [functionsXXXXX]

#

# 71=ilink,11	;  disconnect permanently connected link = *71<node>

# 73=ilink,6	;  disconnect all links

# 76=ilink,13	;  connect link permanent transceive = *76<node>

#

# 6666=cmd,/etc/asterisk/local/check_default.sh XXXXX YYYYY ZZZZZ	; Check if only node XXXXX is connected to YYYYY else reconnect

#									; ZZZZZ is a don't disconnect list in the format Node1,Node2,Node3

# 6667=cmd,touch /etc/asterisk/local/~checkdefault_XXXXX    		; disable check_default.sh

# 6668=cmd,rm -f /etc/asterisk/local/~checkdefault_XXXXX    		; enable check_default.sh

#

#

# [macroXXXXX]

#

# 9=*6666#		; Check if only node XXXXX is connected to YYYYY else reconnect

#

#

#

# If you use allmon2 you can add the following lines into the controlpanel.ini.txt file to allow you 

# to run the script from the webpage and enable/disable the script

#

# [general]

# labels[] = "Default Connections"

# cmds[] = "rpt fun %node% *6666"

# labels[] = "Enable Auto Default Connect"

# cmds[] = "rpt fun %node% *6668"

# labels[] = "Disable Auto Default Connect"

# cmds[] = "rpt fun %node% *6667"

#

#

#









PermanentLink=0


if [ "$1" == "" -o "$2" == "" ]

then

    echo "Usage = check_default.sh [local node] [remote node] [do not disconnect list]"

    exit

fi



DisableFile="/etc/asterisk/local/~checkdefault_$1"

Tempfile="/var/log/checkdefault.$1"

Logfile="/var/log/asterisk/reconnectlog"



if [ -f $DisableFile ]

then

    echo "Disable flag set -- exiting"

    exit

fi



/usr/sbin/asterisk -rx "rpt stats $1" > $Tempfile

sleep 5
echo " "

echo "Dont Disconnect list = $3"

echo " "



IFS=":" 

read -a array1 <<< "$(grep 'Nodes currently connected to us' $Tempfile)"



STATUS=0



IFS="," 

for element in ${array1[1][*]};

do


    # Remove white space from $element 

    shopt -q -s extglob

    element="${element##+([[:space:]])}"

    shopt -q -u extglob



    echo " "

    echo "Process Node |$element|"



    if [[ "$element" == "$2" ]]

    then

        echo "Already connected so do nothing"

        echo Connected ok going to sleep >> $Logfile

        STATUS=1
	python /etc/asterisk/local/ledgreenon.py



    elif [[ "$element" == "<NONE>" ]]

    then

        echo "Not connected to any nodes"

        echo " "
	

        STATUS=0

    

    elif [[ "$element" != "$2" ]]

    then

        echo "Connected to node $element check do not disconnect list"



        if [[ "$3" == *"$element"* ]]

        then

            echo "Node $element is on the do not disconect list"

        else        

            echo "Not on list so disconnecting Node $element"

            /usr/sbin/asterisk -rx "rpt fun $1 *71$element"

            echo $(date) $1 disconnected node $element via check_default.sh >> $Logfile



        fi

    fi

done



unset IFS



if [[ "$STATUS" == "0" ]]

then
            python /etc/asterisk/local/ledgreenoff.py

    echo "Connecting $1 to $2"

    

    if [[ $PermanentLink == 1 ]]

    then

#        /usr/sbin/asterisk  -rx "rpt fun $1 *3$2"

        echo $(date) $1 permanently connected to $2 via check_default.sh >> $Logfile

    else

 #       /usr/sbin/asterisk  -rx "rpt fun 40890 *327066"

        echo $(date) $1 connected to $2 via check_default.sh >> $Logfile

    fi

fi
