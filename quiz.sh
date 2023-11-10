#!/bin/bash

<<doc
Name			: Swathi Gajaram
Date			: 01-07-2023
Description		: Project - Conducting quiz
Sample Input	:
Sample Output	:
doc


function sign_up()
{
	user_arr=(`cat username.csv`)   #Stores all the usernames in .csv file as array
	read -p "Username: " user       #Read username from user
	flag=0                          #To identify whether user is already present
	for i in ${user_arr[@]}         #traversing through all usernames in array
	do
		if [ "$i" = "$user" ]      #if entered username matches in array
		then
			echo -e "\e[31mUsername already exists\e[0m"    #Print error message that user already exists
			sign_up                           #And again ask user for username using recursive function
		    flag=1                     #Update flag if user already exists
		fi
	done
	function pass()
	{
		read -sp "Password: " password      #reading password for signup
		echo
		read -sp "Retype password: " confirm  #Reading confirmation password
		echo
		if [ "$password" = "$confirm" ]   #If password and confirmation password matches
		then
			echo "$user" >> username.csv     #Updating username to username.csv file
			echo "$password" >> password.csv   #Update password in password.csv file
			echo -e "\e[32mSign up successful\e[0m"      #Then display signup successfull
			options          #then again call function for user options
		else
			pass     #if passwords doesn't match again ask for password
		fi
	}
	if [ $flag -eq 0 ]       #If flag remains 0 that means username entered by user is new
	then
		pass                 #Ask for password
	fi
}


function sign_in()
{
	user_arr=(`cat username.csv`)      #store usernames in array
	pswd_arr=(`cat password.csv`)      #Store passwords in array
	read -p "Username: " user          #Read usernames
	flag=0                             #An varaible to identify user name is present or not
	for i in `seq 0 $((${#user_arr[@]}-1))`    #Traversing through array indices
	do
		if [ "${user_arr[i]}" = "$user" ]      #if entered username is present in file then ask password
		then 
			flag=1
			read -sp "Password: " password     #Read password in silent
			if [ "$password" = "${pswd_arr[i]}" ]  #Check if user entered correct password
			then
				echo -e "\n\e[32mSign in successfully\e[0m"       #if matches Signed successfully
				echo -e "1.Take the test\n2.Exit" #Then ask for options
				read -p "Enter option: " opt      #read option
				case ${opt} in
					1)
						quiz      #call quiz function if option is 1
						;;
					2)
						exit      #Exit if option is 2
						;;
					*)            #Default case
						;;
				esac			
			else
				echo -e "\n\e[31mUsername or password is wrong\e[0m"
				sign_in    #If password is wrong again call sign in function
			fi
			break
		fi
	done
	if [ $flag -eq 0 ]    #checking if user found
	then
		echo -e "\e[31mUsername or password is wrong\e[0m"

		sign_in    #calling sign in function if user not found
	fi		
}


function evaluate()
{
	correct_ans=(`cat correct_ans.csv`)  #Storing correct answers in array from file
    user_ans=(`cat user_ans.csv`)        #Storing user answers in array from file
	count=0     #Initialising variable to count correct answers
	for i in `seq 10`  #travesing through each answer
	do
		head -$((5*i)) "questions.csv" | tail -5  #Displaying each question along with options
		if [ "${correct_ans[$((i-1))]}" = "${user_ans[$((i-1))]}" ]  #Checking if user answer is correct for each question
		then
			echo -e "\e[92mCORRECT ANSWER\n\e[34mYour Answer:\e[0m ${user_ans[$((i-1))]}"     
			count=$((count+1))      #Updating count if user answer is correct
		elif [ "${user_ans[$((i-1))]}" = "x" ]    #Checking if user answer is timed out option
		then
			echo -e "\e[33mTIMED OUT\n\e[34mAnswer: \e[0m${correct_ans[$((i-1))]}"  #Printing answer if it is timed out
		else
			echo -e "\e[91mWRONG ANSWER\n\e[34mCorrect answer: \e[0m${correct_ans[$((i-1))]}"     #Printing correct answer if it is wrong answer
		fi
	done
	echo -e "\e[4;96mTotal marks obtained: \e[0m${count}/10"     #Printing marks obtained
}

function quiz()
{
	echo -n > user_ans.csv    #Over writing user answer file every time takes test
	for i in `seq 5 5 50`     #traversing through questions along with options
	do
		
		head -$i "questions.csv" | tail -5   #Displaying each question
		f=0
		for j in `seq 10 -1 1` #generating sequence for 10 secs
		do
			echo -ne "\rEnter the answer in $j "  #Prinitng countdown
			read -t 1 ans     #reading each seconds
			if [ -n "$ans" ]  #checking whether user entered answer
			then	
				f=1
				break  #break loop if user entered answer
			else
				ans=x  #Store an option if user dont enter answer
			fi
		done
		if [ $f -eq 0 ]
		then
			echo
		fi
		echo "$ans" >> user_ans.csv  #Append each question answer in user answer file
	done
	evaluate #After quiz calling evaluate function
}


function options()        #Function to print user functions
{
	echo -e "\e[2m1.Sign up\n2.Sign in\n3.Exit\e[0m"  #Display user opions
	read -p "Enter option: " choice    #Read user options
	case ${choice} in
		1)
			sign_up     #calling sign up function if option is 1
			;;
		2)
			sign_in    #calling sign in function if option is 2
			;;
		3)
			exit       #Exiting if option is 3
			;;
		*)
			;;
	esac
}
options
