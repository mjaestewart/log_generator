#!/bin/bash

################################################
#            OSSEC Log Generator               #
#      Authors:                                #
#                Nathan R. Wray (m4dh4tt3r)    #
#                Mark Stewart                  #
################################################


getTime=$(date -v-3m +%s)
genTime=("100" "10" "25" "36" "22" "41" "600" "55" "74")

osseclog_create () {

directory_name=~/Desktop/log-gen
sensorIP="192.168.23.2"
hostName=("adv-win2k16-dns" "adv-win2k16-dc" "adv-win2k16-ad" "adv-win2k16-iis" "adv-win2k16-sql" "adv-win2k16-cv" "adv-win2k16-dc1" "adv-win2k16-dc2" "adv-win2k16-dc3")
userArr=("jtbowers" "smcappo" "plmarro" "ttarcol" "mstewart" "root" "kdorsey" "dvargas" "thoerger" "rreichert" "dulmer")
userName=${userArr[$(($RANDOM % ${#userArr[@]} +1 ))]}
logArr=("~/Desktop/auth.log")
thisHost=${hostName[$(($RANDOM % ${#hostName[@]} +1 ))]}

if [ -d $directory_name ]
  then
    echo "Directory already exists" > /dev/null
  else
    mkdir $directory_name
fi

for ((i=0; i<10000; i++))
do
  # Get value to increment epoch
  incrementTime=${genTime[$(($RANDOM % ${#genTime[@]} +1 ))]}

  # Add epoch + value of incrementTime
  newTimeEpoch=$((incrementTime + getTime))

  # Take the new epoch value and put it in Apache log format
  newTime=$(date -r $newTimeEpoch "+%m/%d/%Y:%H:%M:%S")

  alertArr=("Login session opened." "Login session closed.")
  msgArr=("su[$((3000 + $((RANDOM % 40000))))]: pam_unix(su:session): session opened for user ${userName} by (uid=0)" \
          "su[$((3000 + $((RANDOM % 40000))))]: pam_unix(su:session): session opened for user ${userName}")

  #Second date is 3 letter month day of month time HH:MM:SS
  echo -e "${newTime} ${sensorIP} Alert Level: $((1 + $(($RANDOM % 10)))); Rule: $((3000 + $(($RANDOM % 40000)))) - ${alertArr[$(($RANDOM % ${#alertArr[@]} +1 ))]}; Location: ${thisHost}->${logArr[$(($RANDOM % ${#logArr[@]} +1 ))]}; ${sensorIP}; Jul 25 14:27:15 ${thisHost} ${msgArr[$(($RANDOM % ${#msgArr[@]} +1 ))]}" >> ~/Desktop/log-gen/ossec-hids.log

  let getTime="${newTimeEpoch}"

  unset -f "${userName[*]}"
  unset -f "${thisHost[*]}"
  break

done

}

for i in {1..100000} 
do 
  osseclog_create
done