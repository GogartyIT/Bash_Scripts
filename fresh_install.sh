#!/bin/bash
#program to configure and install 
# apache 2
# php 5
# mysql
#configure static ip based on user input
# install UFW firewall and confirure for internal access only

#update and upgrade the system
clear
echo "Wellcome to the webserver install program"
echo "This program will install , Apache 2 webserver. PHP5 and MySql"
printf "This program will also configure the nessary files such as your static ip, and will also install and\nconfigure a Firewall.\n"
printf "Press Enter to continue. \n"
read ""
clear
echo "============================"
echo "Updateing system"
echo "============================"
sleep 5
sudo apt-get update
clear
echo "============================"
echo "Update Repo's complete. Now updating your system."
echo "============================"
sleep 5
sudo apt-get upgrade -y
echo "Install complete"
read -p "press enter to continue"

#instll apache2
clear
echo "============================"
echo "Installing Apache2 server"
echo "============================"
sleep 5

sudo apt-get install apache2 -y

echo ""
echo "Install complete"
read -p "press enter to continue"

clear
echo "============================"
echo "installing php5"
echo "============================"
sudo apt-get install php5 libapache2-mod-php5 -y
echo "Install complete"
read -p "press enter to continue"
#secure install of mysql
clear
echo "============================"
echo "Installing  MySql server."

printf "You will have to enter a Secure Password for MySql instalation manager.\n Get one ready now and press Enter when to begin install process.\n"
echo "============================"
read -p ""
sudo apt-get install mysql-server php5-mysql -y
echo "Install complete"
read -p "press enter to continue"
clear
echo "============================"
echo "Starting Secure Install of MySql."
echo "Press enter to all options"
echo "============================"
mysql_secure_installation
echo "Install complete"
read -p "press enter to continue"
#configure static ip
clear
echo "============================"
echo " This proram will now configure the static IP for your Pi."
echo "Please press enter when ready"
echo "============================"
read ""
clear
echo "============================"
echo "Connect your Pi to your network via a ethernet cable"
echo "Press enter when you have completed this step"
echo "============================"
read ""
clear
echo "============================"
echo "Current Network Configuration"
echo "==========================="
echo ""
sleep 3
#assign the values to var x
x=$(sudo ifconfig | grep -E 'inet addr.*Bcast.*Mask*')
#convert x to a string and split on the delimiter " "
IFS=' ' read -ra IPARRAY <<< "$x"

#print the values 
ip=$(echo ${IPARRAY[1]} | cut -d ":" -f2)
echo "Current IP Address : " $ip

broadcast=$(echo ${IPARRAY[2]} | cut -d ":" -f2)
echo "Current Broadcast Address : " $broadcast

netmask=$(echo ${IPARRAY[3]} | cut -d ":" -f2)
echo "Current Netmask Address : " $netmask


#write to file the values in the netstat comand to config.txt
sudo netstat -nr >> config.txt
#write each line to an array ellement
index=0
touch config.txt
while read line ;do
	IPARRAY2[$index]="$line"
	index=$((index+1))
done < config.txt

gateway=$(echo ${IPARRAY2[2]} | cut  -d ' ' -f2)

echo "Current Gateway Address : "  $gateway
network=$(echo ${IPARRAY2[3]} | cut -d ' ' -f1)
if [ $network = "0.0.0.0" ];then 
	network=$(echo ${IPARRAY2[4]} | cut -d ' ' -f1)


fi



echo "Current Network Address : " $network


CONFIRM=true
#flow controol to change IP address to custom

echo ""

echo "Your current IP address is : "$ip

echo ""

while  $CONFIRM ; do
	
	
	read -p  "Would you like to change it ? Type \"n\" to continue or \"y\" to change.  " ans

	if [ "$ans" = "y" ] || [ "$ans" = 'yes' ]; then
		printf " Your IP address must conform to the above standard.\n For example 192.168.1.121\n"
		read -p "Enter your new IP.   " ip
		CONFIRM=false
		
	elif [ "$ans" =  "no" ] || [ "$ans" = "n" ]; then
		CONFIRM=false
		
	else
		printf "You have entered an incorrect option\n"
	fi
done

echo "Your new IP is :" $ip
sleep 3

#clean up files created
rm config.txt
# make copy of origional file 
sudo mv /etc/network/interfaces /etc/network/interfaces.old


# write the new interfaces file 
printf " 
auto lo
iface lo inet loopback

auto eth0
allow-hotplug eth0
iface eth0 inet static

address $ip
netmask $netmask
network $network
broadcast $broadcast
gateway $gateway

auto wlan0
allow-hotplug wlan0
iface wlan0 inet manual
wpa-conf /etc/wpa_supplicant/wpa_supplicant.conf

auto wlan1
allow-hotplug wlan1
iface wlan1 inet manual
wpa-conf /etc/wpa_supplicant/wpa_supplicant.conf



" >> interfaces
sudo mv interfaces /etc/network

echo "Install complete"
read -p "press enter to continue"

clear
echo "============================"
echo "installing UFW firewall"
echo "============================"

sudo apt-get install ufw
#configure to allow SSH and http

sudo ufw limit ssh
sudo ufw allow http

#get ip and configure allow from ip range
sudo ufw allow from 192.168.0.1/24
sudo ufw enable
clear
echo""
echo ""
echo "Your Fire wall has been configured to allow SSH, HTTP and access form oher programs\nsudch as Smaba, FTP ect."
echo "To View th status of your Fire wall enter the command \"sudo ufw status numbered \"."
read -p "Press enter to continue"
echo "System will now reboot."
sleep 5

sudo reboot

	

