#!/bin/bash
#Author : James Gogarty
# Version : 1.0
# Date : 18-02-2024
#This program is a safe alternative to the Linux and Unix rm commands.
#For more information on how to use, please use the README.TXT file

#variables
BIN=""
#FUNCTIONS

#SETUP bin location, read config file or use system standard in Home dir 
setup()
{
	echo "start the set-up"
	if [ ! -f /home/jim/.srm_config ]; then	
		BIN=$HOME/recyclebin
		mkdir $BIN
		echo "echo $BIN"
		
	else 		
		echo" else condition"
		BIN=$(cat $HOME/.srm_config)
		if [ ! -d $BIN ]; then
		
			echo "The recycle bin dose not exist."
			read -p "would you like to create the Bin in your Home directory. Type \"y\" for yes or \"n\" for no : " answer
			loop=1
			while [ $loop -eq 1 ]; do
	 
				if [ "$answer" = "y" ]; then
					mkdir $BIN
					loop=0
				elif [ "$answer" = "n" ]; then
					echo "Program will now close"
					loop=0
					exit 2
				else 
					echo "You have entered an invalid option"

				fi
			done		
		fi
	fi
}

#delete file function
deleteFile ()
{
	#TODO: add a for loop to cycle through arguments
	echo "delete var"
	echo $1
	# get the inode of the file, which will be added to the filename when moving to the bin
	inode=$(ls -i | grep $1 | cut -d " " -f1)	
	# Add the inode number to the file and then move it to the bin
	echo "variable $1"
	echo "echo inode $inode"
	mv  $1 $1_$inode
	echo "echo new file name $1"
	echo $1_$inode
	mv  $1_$inode $BIN
	echo "the file is now in the bin, and can be forgotten about"
}

filecheck ()
{
# If the file to delete exits, the file will be moved to the Bin folder
#add loop if more than one argument
for var in "$@" ; do 
	echo "filecheck"
	echo $var
	if [ -f $var ]; then 
		echo "File : $var : will now be deleted"
		read -p "Are you sure you whish to delete a file : " confirm
		if [ "$confirm" = "y" ] || [ "$confirm" = "yes" ]; then 
	 
	        	deleteFile $var
		else 
			echo "This file will now be deleted."
		fi
	else 
        	echo "This is not a correct file name, or the path is a directory and can not be removed with this program."
	fi
done 
}
#calling setup function, i.e is there a config file or a bin folder
setup $@
#calling filecheck, i.e does the file exist ?
filecheck $@


