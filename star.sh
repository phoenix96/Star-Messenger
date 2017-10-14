#					*****************************************************
#					*              STAR MESSENGER			    *
#					*      S-Sarthak Kulshreshtha (9914103156) F5       *
#					*      T-Tarun Agarwal	      (99141031  ) F5	    *
#					*      A-Ayush Garg           (9914103152) F5       *
#					*      R-Rishabh Jain         (9914103137) F5       *
#					*****************************************************
check_notifications(){
#welcome
if [ -s notifications ]
	then 
	no=`wc -l notifications | cut -f1 -d" "`
	no_of_not=`expr $no`
	if  [  $no_of_not -gt 0  ]
	then
		echo -e "\t\t\tyou have $no_of_not new notifications from"
		cat notifications
		echo -e "\n\n********************************************************************************\n\n"
		sed '/.*/d' notifications >> $$
		mv $$ notifications
	else
		echo -e "\t\t\tyou have no new notifications"
		echo -e "\n\n********************************************************************************\n\n"
	fi
fi
}

send(){
user=`pwd`
user=`expr $user : '.*\(..........\)'`
echo $user
msg="NOTNULL"     
while [ -n "$msg" ]
	do 
		tput clear
		tail -10 $cin
		echo "_____________________________________________________"
		read msg
		echo "$user : "$msg >> $cin
	done
sed '$ d' $cin >> $$
mv $$ $cin

cp ./$cin ../$cin/$user 

echo "$user" >> ../$cin/notifications   
}

Message(){
tput clear
welcome
check_notifications
count=`wc -l Contacts | cut -f1 -d" "`
if  [  $count -eq 0  ]
	then 
	echo -e "Contact list empty\nAdd new contacts" && sleep 2;star_main
	else
	cat -n Contacts
fi
echo -e "\n\nEnter Contact id"
read no
cin=`sed -n "$no p" Contacts | cut -d" " -f2`
tput clear	
if [ ! -f $cin ]
	then
	echo "" >> $cin
	sed '$ d' $cin >> $$
	mv $$ $cin
	send
	else 
	send
fi
star_main
}

welcome(){
echo -e "********************************************************************************\n\n\t\t\tWELCOME TO STAR MESSENGER\n\n********************************************************************************\n\n"
}

SignUp() {
tput clear
welcome
echo -e "\t\t\tSIGNUP-PAGE"
echo "Enter Mobile number"
read mob_num
echo "Enter Password"
read pass
len=`expr $mob_num : ".*"`
if [ $len -eq 10 ]
	then
		if [[ $mob_num =~ [a-zA-Z@#$%^*_+] ]];
			then
			echo "ERROR : Redirecting to main page..." &&  sleep 3 ; main
		else
		#grep "^$mob_num[|]$pass$" DB && echo "This number has already registered for STAR Messenger" && sleep 3;main 
		grep "^$mob_num" DB
			if [ $? -eq 0 ]
				then
				echo "Member already registered for Star Messenger"			
				sleep 3
				main
			else
			mkdir $mob_num
			echo "$mob_num|$pass" >> DB
			echo "added sucessfully"
			cd $mob_num > /dev/null
			echo "" >> notifications
			sed '/.*/d' notifications >> $$
			mv $$ notifications
			echo "" >> Contacts
			sed '/.*/d' Contacts >> $$
			mv $$ Contacts
			cd - > /dev/null
			echo "Redirecting to Login Page..."
			sleep 3
			fi 
		Login
		fi
		else "ERROR : Redirecting to main page..." &&  main
fi
}

Login(){
tput clear
welcome
echo -e "\t\t\tLOGIN-PAGE"
echo "Enter Mobile number"
read mob_num
echo "Enter Password"
read pass
grep "^$mob_num[|]$pass$" DB
if [ $? -eq 0 ]
then
	cd $mob_num
	star_main
else
	echo "INVALID" 
fi 
}

Log_out(){
cd - > /dev/null
main
}

star_main(){
tput clear
welcome
echo -e "\t\t\t1. Manage contacts\n\n\t\t\t2. Message\n\n\t\t\t3. Log_out"
read var
case $var in 
1) 	tput clear
   	Manage_contacts 	
	;;
2) 	tput clear
   	Message 
	;;
3) 	tput clear
   	Log_out 
	;;
*) echo -e "\t\t\tInvalid input" && sleep 3;star_main ;;
esac
}

new () {
tput clear
welcome
echo "Enter the name"
read name
size=${#name}
if [ $size -ge 4 ]
then
	echo "Enter Phone number"
	read number
	size=${#number}
	user=`pwd`
	user=`expr $user : '.*\(..........\)'`
	#echo $user
	if [ $size -eq 10 ]
	then
		#echo "Hello"		
		if [[ $number =~ [a-zA-Z@#$%^*_+] ]];
		then
			echo "Wrong Input!!"
		else
			cd -
			grep "^$number" DB
			if [ $? -eq 0 ]
			then
			cd $user
			echo "$name $number" >> Contacts
			echo "$name added succesfully."
			sleep 3
			else
			echo "Member not registerd for star messenger"
			sleep 3
			fi 
		fi 
	else
	echo "Wrong Input!!"
	fi
else
	echo "Name entered seems invalid. Please try again."
fi

sort -t" " -k 1 Contacts > $$
mv $$ Contacts
Manage_contacts
}

edit () {
tput clear
welcome
display
echo ""
echo "_Edit contact id_ "
read num
new
sed "$num d" Contacts > $$
mv $$ Contacts
Manage_contacts
}

delete () {
tput clear
welcome
display
echo "Enter the contact id to delete"
read num
check=`wc -l contact_list | cut -d" " -f1`
echo $check
if [ $num -gt 0 -a $num -le $check ] 
then
	sed "$num d" Contacts >> $$
	mv $$ Contacts
	echo "Delete Succesful"
else
	echo "Not valid"
fi
Manage_contacts
}

display () {
tput clear
welcome
if [ -s Contacts ]
then
	cat -n Contacts
else 
	echo "Contact list empty" && sleep 3;Manage_contacts
fi
}

Manage_contacts() {
tput clear
welcome
echo -e "\t\t\t1. Add new contact"
echo -e "\t\t\t2. Edit Contact"
echo -e "\t\t\t3. Delete Contact"
echo -e "\t\t\t4. Display all"
echo -e "\t\t\t5. Exit Contact Manager"
read ch
case "$ch" in
1)	new
	;;
2)	edit
	;;
3)	delete
	;;
4)	display
	;;
5) 	echo "Exit" && sleep 3;star_main
	;;
*)	echo "INVALID"
	;;
esac
}

main(){
tput clear
welcome
echo -e "\t\t\t1. Sign Up\n\n\t\t\t2. Login\n\n\t\t\t3. Exit"
read var
case $var in 
1) 	SignUp 
   	;;
2)	Login 
   	;;
3)	exit 
   	;;
*)	echo -e "\t\t\tInvalid input" && sleep 3;main 
   	;;
esac
}

main
