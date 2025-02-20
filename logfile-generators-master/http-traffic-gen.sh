#!/bin/bash

################################################
#            HTTP Traffic Log Generator        #
#      Authors:                                #
#                Nathan R. Wray (m4dh4tt3r)    #
#                Mark Stewart                  #
################################################

# Script to generate Apache logs
# Can be expanded upon to include simulated attacks
# (e.g. - SQLi, XSS, etc.), the IPs can be changed to
# meet any use case, and the User Agents can be expanded on.

getTime=$(date -v-3m +%s)
genTime=("100" "10" "25" "36" "22" "41" "600" "55" "74")


httplog_create () {

directory_name=~/Desktop/log-gen
httpCode=("200 OK" "302 Found" "304 Not Modified" "400 Bad Request" "401 Unauthorized" "403 Forbidden" "404 Not Found" "500 Internal Server Error" "502 Bad Gateway")
httpMethod=("GET" "POST" "HEAD")
hostName=("salt" "pepper" "oregano" "-" "parsley")
urlBase=("http://www.google.com" "http://example.com" "http://yahoo.com" "http://info.ru" "http://access.polytech.org" "http://bananarama.co.in")
urlPath=("/example/path/index.php" "/search?uniqueID=195d5acc43ff4a&stmt=0" "/webhp?sourceid=chrome-instant&ion=1&espv=2&es_th=1&ie=UTF-8#q=url+context" \
         "/index.html" "/" "/login.php" "/images/occassions/birthday.png" "" "index.php?q=hello&p=34.99")
userAgent=("Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/43.0.2357.130 Safari/537.36   Chrome 43.0 Win7 64-bit" \
           "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_4) AppleWebKit/600.7.12 (KHTML, like Gecko) Version/8.0.7 Safari/600.7.12  Safari 8.0 MacOSX" \
           "Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/43.0.2357.130 Safari/537.36   Chrome 43.0 Win8.1 64-bit" \
           "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/43.0.2357.130 Safari/537.36 Chrome 43.0 MacOSX" \
           "Mozilla/5.0 (Windows NT 6.1; WOW64; rv:39.0) Gecko/20100101 Firefox/39.0 Firefox 39.0 Win7 64-bit" \
           "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/43.0.2357.134 Safari/537.36 Chrome 43.0 Win7 64-bit" \
           "Wget/1.9.1" "-")

if [ -d $directory_name ]
  then
    echo "Directory already exists" > /dev/null
  else
    mkdir $directory_name
fi

for ((i=0; i<10000; i++))
do
  genIP=("192.168.$((RANDOM % 10)).$((1 + $((RANDOM % 254))))" "65.47.$((RANDOM % 254)).$((1 + $((RANDOM % 254))))" "39.$((RANDOM % 254)).$((RANDOM % 10)).$((1 + $((RANDOM % 254))))")
  getIP="${genIP[$(($RANDOM % ${#genIP[@]} +1 ))]}"

  # Get value to increment epoch
  incrementTime="${genTime[$(($RANDOM % ${#genTime[@]} +1 ))]}"
  # Add epoch + value of incrementTime
  newTimeEpoch=$((incrementTime + getTime))

  # Take the new epoch value and put it in Apache log format
  newTime=$(date -r $newTimeEpoch "+%m/%d/%Y:%H:%M:%S")

  # Set url path
  getURL=${urlPath[$(($RANDOM % ${#urlPath[@]} +1 ))]}
  # Write the generated Apache content to a log file
  echo -e "${getIP} ${hostName[$(($RANDOM % ${#hostName[@]} +1 ))]} - [${newTime}] \"${httpMethod[$(($RANDOM % ${#httpMethod[@]} +1 ))]} ${getURL} HTTP/1.1\" ${httpCode[$(($RANDOM % ${#httpCode[@]} +1 ))]} $RANDOM \"${urlBase[$(($RANDOM % ${#urlBase[@]} +1 ))]}${getURL}\" \"${userAgent[$(($RANDOM % ${#userAgent[@]} +1 ))]}\"" >> ~/Desktop/log-gen/access.log

  let getTime="${newTimeEpoch}"

  unset -f "${httpCode[*]}"
  unset -f "${httpMethod[*]}"
  unset -f "${hostName[*]}"
  unset -f "${urlBase[*]}"
  unset -f "${urlPath[*]}"
  unset -f "${userAgent[*]}"
  unset -f "${genIP[*]}"
  unset -f "${getIP[*]}"
  break

done

}

for i in {1..100000} 
do 
  httplog_create
done