#!/bin/bash

################################################
#            NetFlow Log Generator             #
#      Authors:                                #
#                Nathan R. Wray (m4dh4tt3r)    #
#                Mark Stewart                  #
################################################

# Script to generate Netflow logs
# Can be expanded upon to include simulated attacks
# (e.g. - SQLi, XSS, etc.), the IPs can be changed to
# meet any use case, and the User Agents can be expanded on.

getTime=$(date -v-3m +%s)
genTime=("100" "10" "25" "36" "22" "41" "600" "55" "74")

netflowlog_create () {

directory_name=~/Desktop/log-gen
randNum=$((1 + $((RANDOM % 9))))
httpLang=("en-US,en;q=0.${randNum}" "es-PR,es;q=0.${randNum}" "en-GB,en;q=0.${randNum}")
httpContent=("image/jpeg" "text/html" "text/plain" "application/pdf" "video/jpeg")
httpCode=("200 OK" "302 Found" "403 Forbidden" "404" "500")
httpMethod=("GET" "POST" "HEAD")
srcPort=$((1024 + $((RNADOM % 65535))))
dstPort=("443" "80" "10000" "8080" "8888" "9003" "9001")
urlProt=("http://" "https://")
urlBase=("www.google.com" "example.com" "yahoo.com" "info.ru" "access.polytech.org" "bananarama.co.in")
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
  srcIP="${genIP[$(($RANDOM % ${#genIP[@]} +1 ))]}"
  dstIP="${genIP[$(($RANDOM % ${#genIP[@]} +1 ))]}"

  # Get value to increment epoch
  incrementTime="${genTime[$(($RANDOM % ${#genTime[@]} +1 ))]}"
  # Add epoch + value of incrementTime
  newTimeEpoch=$((incrementTime + getTime))

  # Take the new epoch value and put it in Apache log format
  newTime=$(date -r $newTimeEpoch "+%m/%d/%Y:%H:%M:%S")

  # Build out URLs
  getPath=${urlPath[$(($RANDOM % ${#urlPath[@]} +1 ))]}
  getProt=${urlProt[$(($RANDOM % ${#urlProt[@]} +1 ))]}
  getBase=${urlBase[$(($RANDOM % ${#urlBase[@]} +1 ))]}

  echo -e "${newTime} ${srcIP} ${srcPort} ${dstIP} ${dstPort[$(($RANDOM % ${#dstPort[@]} +1))]} ${httpMethod[$(($RANDOM % ${#httpMethod[@]} +1 ))]} ${getBase} ${getProt}${getBase}${getPath} HTTP_Args HTTP_Via ${userAgent[$(($RANDOM % ${#userAgent[@]} +1 ))]} ${httpCode[$(($RANDOM % ${#httpCode[@]} +1))]} ${httpContent[$(($RANDOM % ${#httpContent[@]} +1 ))]} $RANDOM ${httpLang[$(($RANDOM % ${#httpLang[@]} +1 ))]} ${getBase}" >> ~/Desktop/log-gen/netflow.log

  let getTime="${newTimeEpoch}"

  unset -f "${genIP[*]}"
  unset -f "${srcIP[*]}"
  unset -f "${dstIP[*]}"
  unset -f "${getPath[*]}"
  unset -f "${getProt[*]}"
  unset -f "${getBase[*]}"
  break

done

}

for i in {1..100000} 
do 
  netflowlog_create
done

