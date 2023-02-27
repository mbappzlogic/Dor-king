#!/bin/bash

echo
echo
echo -e "\033[1;31m██████╗░░█████╗░██████╗░░░░░░░██╗░░██╗██╗███╗░░██╗░██████╗░\033[0m"
echo -e "\033[1;31m██╔══██╗██╔══██╗██╔══██╗░░░░░░██║░██╔╝██║████╗░██║██╔════╝░\033[0m"
echo -e "\033[1;31m██║░░██║██║░░██║██████╔╝█████╗█████═╝░██║██╔██╗██║██║░░██╗░\033[0m"
echo -e "\033[1;31m██║░░██║██║░░██║██╔══██╗╚════╝██╔═██╗░██║██║╚████║██║░░╚██╗\033[0m"
echo -e "\033[1;31m██████╔╝╚█████╔╝██║░░██║░░░░░░██║░╚██╗██║██║░╚███║╚██████╔╝\033[0m"
echo -e "\033[1;31m╚═════╝░░╚════╝░╚═╝░░╚═╝░░░░░░╚═╝░░╚═╝╚═╝╚═╝░░╚══╝░╚═════╝░ \033[0m"
echo -e "\033[1;31m              @appzlogic.com          \033[0m"



# Prompt user to provide a choice 
echo  -e "\033[1;33m Reconnaissance \033[0m"
echo 
echo  -e "\033[1;32m 1.Google Dork \033[0m"
echo  -e "\033[1;32m 2.Github Dork \033[0m"

#echo -e "\033[1;32m Select: read option \033[0m "
echo
read -p " Select:  " option


if [ $option -eq 2 ]
then 

#Promt user to provide a domain name
echo
echo -e "\033[1;35m Enter a Domain Name (e.g. example.com): \033[0m"
echo
read target

#Check weather the user is logged into github or not
# Set the browser name and cookie file path
BROWSER="Firefox"

#read cookie path and cut the profile name
cookie_paths=$(echo Path= ~/.mozilla/firefox/*.default-*/cookies.sqlite)
profile=$(echo "$cookie_paths" | cut -d '/' -f6)
#echo "$profile"

#provide profile name and access cookie
COOKIES_FILE="${HOME}/.mozilla/firefox/$profile/cookies.sqlite"

# Check if the cookie file exists
if [ ! -f "${COOKIES_FILE}" ]; then
  echo "Error: ${COOKIES_FILE} not found"
  exit 1
fi

# Read the cookies from the database
COOKIES=$(sqlite3 -separator '  ' "${COOKIES_FILE}" "SELECT name, value FROM moz_cookies WHERE host LIKE '%github.com%'")

# Print the cookies
echo "${COOKIES}" |  if grep -q 'yes' ; then

    # If logged in, open Firefox
	#echo  -e "\033[1;33m Select Output format \033[0m"
	#echo 
	#echo  -e "\033[1;32m 1.HTML \033[0m"
	#echo  -e "\033[1;32m 2.JSON \033[0m"
	#echo
	#read -p " Select:  " opchoice

	touch $target.output.html
	touch $target.output.json
	echo "GitHub Dorks Result for $target:<br> " >> $target.output.html
	echo " " >> $target.output.html 
	echo "GitHub Dorks Result for $target: " >> $target.output.json
	echo "[" >> $target.output.json



    for dorks in $(cat dorks.txt)
        do firefox  "https://github.com/search?q=$target $dorks&type=code" &
	sleep 1

	url="https://github.com/search?q=$target $dorks&type=code"
	#echo "GitHub Dorks Result" 
  	echo "<a href=\"$url\">$url</a><br>" >> $target.output.html
	echo "  {\"URL\": \"$url\"}," >> $target.output.json

 done 
	echo "]" >> $target.output.json

else
    # If Not logged in, prompt the user to log in
    echo 
    echo  -e "\033[1;33m Please Login to Github Before Running GitDorks \033[0m"
    echo 

fi

elif [ $option -eq 1 ]
then 

#Promt user to provide a domain name
echo 
echo -e "\033[1;35m Enter a domain name (e.g. example.com): \033[0m"
echo
read  target

queries=("site:$target password"
"intext:'index of /' site:$target"
"intext:'wp-content' site:$target"
"intext:'config.php' site:$target"
"inurl:'phpinfo.php' site:$target"
"site:$target intitle:phpMyAdmin"
"inurl:cache site:$target"
"site:$target ext:php intext:'$mysqli'"
"intext:'login' site:$target"
"site:$target intext:'Error 404'"
"site:$target intext:'error_log'"
"site:$target intext:password"
"inurl:admin site:$target"
"site:$target 'confidential'"
"site:$target filetype:pdf"
"site:$target intext:'username' intext:'password'"
"related:$target"
"cache:$target"
"info:$target"
"intext:default password site:$target")

touch $target.output.html
touch $target.output.json
echo "Google Dorks Result for $target:<br>" >> $target.output.html
echo " " >> $target.output.html
touch $target.output.json
echo "Google Dorks Result for $target: " >> $target.output.json
echo "[" >> $target.output.json


for query in "${queries[@]}"
do
# Construct the Google search URL using the user's input
firefox "https://www.google.com/search?q=${query}" &
sleep 1

url="https://www.google.com/search?q=${query}"
# save Google Dorks Result in html file
echo "<a href=\"$url\">$url</a><br>" >> $target.output.html
#save  google dorks result in json file
echo "  {\"URL\": \"$url\"}," >> $target.output.json

done
echo "]" >> $target.output.json

else
echo
echo -e "\033[1;35m Please Enter a Valid Choice \033[0m"
echo
fi
       
