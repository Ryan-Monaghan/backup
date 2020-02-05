#!/usr/bin/env bash

#Scripting for System Automation COMP9053 Assignment 1 - Task 5
#Name: Ryan Monaghan
#ID: R00115129
#Class:

bold=$(tput bold) #variable to format text as bold
normal=$(tput sgr0) #variable to format text as normal
help="\n${bold}Script to Archive Files\n\n ${bold}NAME\n\n - ${normal}./backup.sh - Archives files specified as parameters into a single archive.\n\n${bold}SYNOPSIS\n\n./backup.sh ${normal}\e[4m[FILE]\e[0m\n${bold}e.g. - ${normal}./backup.sh file1 file2 'file3 with spaces' file4\n\n${bold}SWITCHES \n\n -h | --help ${normal}Print the Help menu to the terminal.\n${bold} -f ${normal}Produces a compressed .tar.gz archive.\n${bold} -e ${normal}Encrypts the archive using OpenSSL.\n\n${bold}DESCRIPTION\n\n - ${normal}To archive files, invoke the script, and add the names of the files you would like to archive as parameters, seperate the name of each file with a space.\n ${bold}- ${normal}Please enclose files with spaces between '', for example 'Hello World'\n"

#HELP MENU#If the value of $1 is equal to -h or --help
if [ "$1" == "-h" ] || [ "$1" == "--help" ]; then #do the following
	printf "$help" #print the help menu to the screen
	exit 1 #force exit script

elif ((${#}<1)) #else if the number of parameters given is less than one, print error and guide user toward help menu
	then #do the following
		echo "${0} :ERROR: No parameters provided. Please see -h or --help for usage." 1>&2 #redirect error message from channel1, to channel 2
		exit 2 #force exit script

elif [ "$1" == "-f" ]; then #else if the first parameter is the -f switch
	mkdir tempfolder #create a temporary folder
	for file in "$@" #for each file passed as a parameter
		do #do the following
			cp "$file" "tempfolder" #copy each file to a temporary folder
			tar czf backup.tar.gz "tempfolder" #archive and gzip compress the files/folder using tar
		done #finish loop
		rm -r tempfolder #delete the temporary folder
		echo "${@} have been added to a compressed archive called:backup.tar.gz"

elif [ "$1" == "-fe" ] || [ "$1" == "-ef" ]; then #else if the first parameter contains both the -f and -e switches
	mkdir tempfolder #create a temporary folder
	for file in "$@" #for each file passed as a parameter
		do #do the following
			cp "$file" "tempfolder" #copy each file to a temporary folder
			tar czf backup.tar.gz "tempfolder" #archive and gzip compress the files/folder using tar
			#source ./encrypt.sh
		done #finish loop
		rm -r tempfolder #delete the temporary folder
		openssl enc -e -aes256 -in "backup.tar.gz" -out "backup.tar.gz".enc #encrypt the gzipped archive using OpenSSL
		rm -r backup.tar.gz #delete the previously archived and gzipped folder, as we only want the encrypted version
		echo "${@} have been added to an encrypted compressed archive called:backup.tar.gz.enc"

elif [ "$1" == "-e" ] || [ "$1" == "-e" ]; then #else if the first parameter contains the -e switch
	mkdir tempfolder #create temporary folder
	for file in "$@" #for each file passes as a parameter
		do #do the following
			cp "$file" "tempfolder" #copy each file to a temporary folder
			tar cf backup.tar "tempfolder"
			#source ./encrypt.sh
		done #finish loop
		rm -r tempfolder #delete the temprary folder
		openssl enc -e -aes256 -in "backup.tar" -out "backup.tar".enc #encrypt the archive using OpenSSL
		rm -r backup.tar #delete the previously archived folder, as we only want the encrypted version
		echo "${@} have been added to an encrypted archive called:backup.tar.enc"

else #otherwise, for each file given as a parameter
	mkdir tempfolder #create temporary folder
	for file in "$@" #for each file passed as a parameter
		do #do the following
			cp "$file" "tempfolder" #copy each file to a temporary folder
			tar cf backup.tar "tempfolder" #archive the files/folder using tar
		done #finish loop
		rm -r tempfolder #delete the temporary folder
		echo "${@} have been added to an archive called:backup.tar"
fi #end if statement
