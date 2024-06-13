#!/bin/bash

################################################
#            IPTables Log Generator            #
#      Authors:                                #
#                Nathan R. Wray (m4dh4tt3r)    #
#                Mark Stewart                  #
################################################

getTime=$(date -v-3m +%s)
genTime=("100" "10" "25" "36" "22" "41" "600" "55" "74")


iptablelog_create () {

directory_name=~/Desktop/log-gen
hostName=("adv-win2k16-dns" "adv-win2k16-dc" "adv-win2k16-ad" "adv-win2k16-iis" "adv-win2k16-sql" "adv-win2k16-cv" "adv-win2k16-dc1" "adv-win2k16-dc2" "adv-win2k16-dc3")
protType=("TCP" "UDP" "ICMP")      
thisHost="${hostName[$(($RANDOM % ${#hostName[@]} +1 ))]}"
actionArr=("ACCEPT" "DROP")
interfaceArr=("eth0" "eth1" "eth2" "vlan200" "vlan300" "vlan400" "br0")

if [ -d $directory_name ]
  then
    echo "Directory already exists" > /dev/null
  else
    mkdir $directory_name
fi

for ((i=0; i<10000; i++))
do
  genIP=("192.168.$((RANDOM % 10)).$((1 + $((RANDOM % 254))))" "65.47.$((RANDOM % 254)).$((1 + $((RANDOM % 254))))" "39.$((RANDOM % 254)).$((RANDOM % 10)).$((1 + $((RANDOM % 254))))")
  srcIP="${genIP[$RANDOM % ${#genIP[@]}]}"
  dstIP="${genIP[$RANDOM % ${#genIP[@]}]}"

  srcPort=$((1 + $((RNADOM % 65535))))
  dstPort=$((1 + $((RNADOM % 65535))))
  
  pktRsp=("ACK SYN URGP=0" "SYN URGP=0" "ACK URGP=0" "ACK FIN URGP=0" "ACK PSH URGP=0" "ACK PSH FIN URGP=0")
  optionalArr=("WINDOW=$((15000 + $((RANDOM % 60000)))) RES=0x00 ${pktRsp[$RANDOM % ${#pktRsp[@]}]}" "LEN=$((20 + $((RANDOM % 2000))))")
  
  # Get value to increment epoch
  incrementTime="${genTime[$(($RANDOM % ${#genTime[@]} +1 ))]}"

  # Add epoch + value of incrementTime
  newTimeEpoch=$((incrementTime + getTime))

  # Take the new epoch value and put it in Apache log format
  newTime=$(date -r $newTimeEpoch "+%m/%d/%Y:%H:%M:%S")

  #Second date is 3 letter month day of month time HH:MM:SS
  echo -e "${newTime} ${thisHost} kernel: ${actionArr[$(($RANDOM % ${#actionArr[@]} +1 ))]} IN=${interfaceArr[$(($RANDOM % ${#interfaceArr[@]} +1 ))]} OUT=${interfaceArr[$(($RANDOM % ${#interfaceArr[@]} +1 ))]} SRC=${srcIP} DST=${dstIP} LEN=${RANDOM} TOS=0x00 PREC=0x00 TTL=$((20 + $((RANDOM % 50)))) ID=$((15000 + $((RANDOM % 60000)))) PROTO=${protType[$(($RANDOM % ${#protType[@]} +1 ))]} SPT=${srcPort} DPT=${dstPort} ${optionalArr[$(($RANDOM % ${#optionalArr[@]} +1 ))]}" >> ~/Desktop/log-gen/iptables.log


  let getTime="${newTimeEpoch}"

  unset -f "${protType[*]}"
  unset -f "${thisHost[*]}"
  unset -f "${hostName[*]}"
  unset -f "${actionArr[*]}"
  unset -f "${interfaceArr[*]}"
  unset -f "${userAgent[*]}"
  unset -f "${genIP[*]}"
  unset -f "${srcIP[*]}"
  unset -f "${dstIP[*]}"
  unset -f "${srcPort[*]}"
  unset -f "${dstPort[*]}"
  unset -f "${pktRsp[*]}"
  unset -f "${optionalArr[*]}"
  break

done

}


for i in {1..100000} 
do 
  iptablelog_create
done