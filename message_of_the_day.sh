#!/usr/bin/env bash
#Bash script to change the message of the day on the Linux command line login. 
#this script will add a pun from the pun of the day site below
#

#assign values to today's date and  last date.
#if the last sate is less than today's date the script will continue and 
#rewrite the motd file located at /ect/motd 

#last date will be filed in the root dir when CRON is handling job
#As root will run this script, the location of date the date file needs to 
#be in the roots home dir.
last_date=$(cat "/home/root/.date_log.txt")
echo "last date : "$last_date
today=$(date +"%d-%m-%Y")
echo "todays date : "$today
if [[ "$last_date" < "$today" ]];then
	echo $today > .date_log.txt
	#read index page from pun of the day and write to a temp file
	
	#CHANGE TO AN ARRAY LIST AND CHECK ARRAY.
	wget www.punoftheday.com -O temp.txt
	# read file line by line to find pun and assign to variable
	while read line ;do
        	if [[ $line ==  *"dropshadow"* ]]; then
                	PUNLINE=$line
        	fi
	done < temp.txt

	# add log file 
	LOGFILE=$(tail -4 /home/jim/log.txt) 
	
	#cut the pun out of the line of text
	cutpun=$(echo $PUNLINE | cut -d ';' -f2)
	finalcut=$(echo $cutpun | cut -d '&' -f1)
	#wirte the new M.O.T.D file
	# add update messages about auto backup and auto update .
	#add last log messages from log file
	printf "
Welcome to the JaGo Server.
Current users online : 
`w`

Current Date Time is  :`date +"%A, %e %B %Y, %r"`

Pun of the day : $finalcut

IP Addresses of Server10x: `/sbin/ifconfig eth0 | /bin/grep "inet addr" | /usr/bin/cut -d ":" -f 2 | /usr/bin/cut -d " " -f 1`
Update and Upgrade Logs :
	
$LOGFILE
	" >> motd.txt
	
	#remove temp files
	sudo mv motd.txt /etc/motd
	sudo chown root:root /etc/motd
	sudo rm temp.txt

fi #END IF 
#end of program
