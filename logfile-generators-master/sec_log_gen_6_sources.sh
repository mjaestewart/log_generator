#!/bin/bash

################################################
#            1. OSSEC Log Generator            #
#            2. NetFlow Log Generator          #
#            3. SNORT Log Generator            #
#            4. Syslog Log Generator           #
#            5. HTTP Traffic Log Generator     #
#            6. IP Tables Log Generator        #
#                                              #
#      Authors:                                #
#                Nathan R. Wray (m4dh4tt3r)    #
#                Mark Stewart   (Splunker)     #
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


snortlog_create () {

directory_name=~/Desktop/log-gen
sensorIP="192.168.23.8"
hostName=("adv-win2k16-dns" "adv-win2k16-dc" "adv-win2k16-ad" "adv-win2k16-iis" "adv-win2k16-sql" "adv-win2k16-cv" "adv-win2k16-dc1" "adv-win2k16-dc2" "adv-win2k16-dc3")
protType=("TCP" "UDP" "ICMP")
snortAlerts=("Attempted Administrator Privilege Gain" "Attempted User Privilege Gain" \
             "Inappropriate Content was Detected" "Potential Corporate Privacy Violation" \
             "Executable code was detected" "Successful Administrator Privilege Gain" \
             "Successful User Privilege Gain" "A Network Trojan was detected" \
             "Unsuccessful User Privilege Gain" "Web Application Attack" "Attempted Denial of Service" \
             "Attempted Information Leak" "Potentially Bad Traffic" \
             "Attempt to login by a default username and password" "Detection of a Denial of Service Attack" \
             "Misc Attack" "Detection of a non-standard protocol or event" "Decode of an RPC Query" \
             "Denial of Service" "Large Scale Information Leak" "Information Leak" \
             "A suspicious filename was detected" "An attempted login using a suspicious username was detected" \
             "A system call was detected" "A client was using an unusual port" \
             "Access to a potentially vulnerable web application" "Generic ICMP event" "Misc activity" \
             "Detection of a Network Scan" "Not Suspicious Traffic" "Generic Protocol Command Decode" \
             "A suspicious string was detected" "Unknown Traffic" "A TCP connection was detected")    
                   
etMsg=("GPL ACTIVEX WEB-CLIENT tsuserex.dll COM Object Instantiation Vulnerability" \
       "ET ACTIVEX EasyMail Quicksoft ActiveX Control Remote code excution clsid access attempt" \
       "ET ACTIVEX Black Ice Fax Voice SDK GetItemQueue Method Remote Code Execution Exploit" \
       "ET ATTACK_RESPONSE Metasploit Meterpreter File/Memory Interaction Detected" \
       "ET CNC Palevo Tracker Reported CnC Server TCP group 1" \
       "GPL CHAT Yahoo IM conference message" \
       "ET CURRENT_EVENTS Psyb0t Bot Nick" \
       "ET CURRENT_EVENTS Known Malicious Facebook Javascript" \
       "ET CURRENT_EVENTS Exploit Kit Exploiting IEPeers" \
       "ET CURRENT_EVENTS Runforestrun Malware Campaign Infected Website Landing Page Obfuscated String JavaScript DGA" \
       "ET CURRENT_EVENTS Possible Glazunov Java exploit request /9-10-/4-5-digit" \
       "ET CURRENT_EVENTS - CommentCrew Possible APT c2 communications sleep5" \
       "ET CURRENT_EVENTS Blackhole 16-hex/a.php Jar Download" \
       "ET CURRENT_EVENTS DRIVEBY Styx - TDS - Redirect To Landing Page" \
       "ET CURRENT_EVENTS SUSPICIOUS winhost" \
       "ET CURRENT_EVENTS Possible Upatre SSL Compromised site sabzevarsez.com" \
       "GPL DELETED MDaemon authentication overflow single packet attempt" \
       "ET DELETED SMTP Secret" \
       "ET DELETED Trojan.Downloader.Time2Pay.AQ" \
       "ET DELETED Downloader Checkin Pattern Used by Several Trojans" \
       "ET POLICY Suspicious inbound to MSSQL port" \
       "ET SCAN Potential VNC Scan" \
       "ET POLICY HTTP traffic on port 443" \
       "ET POLICY SUSPICIOUS *.doc.exe in HTTP URL" \
       "ET POLICY SUSPICIOUS *.pdf.exe in HTTP URL" \
       "ET DELETED User-Agent " \
       "ET DELETED Unknown Trojan Checkin 1" \
       "ET DELETED HTTP Request to a Zeus CnC DGA Domain opldkflyvlkywuec.ru" \
       "ET DELETED DNS Query to Zeus CnC DGA Domain opldkflyvlkywuec.ru Pseudo Random Domain" \
       "ET DELETED Win32/Kelihos.F Checkin 6" \
       "GPL DNS SPOOF query response with TTL of 1 min. and no authority" \
       "ET EXPLOIT Computer Associates Mobile Backup Service LGSERVER.EXE Stack Overflow" \
       "GPL EXPLOIT ISAKMP initial contact notification without SPI attempt" \
       "ET GAMES TrackMania Request GetConnectionAndGameParams" \
       "ET INFO JAVA - Java Class Download" \
       "ET INFO SUSPICIOUS SMTP EXE - RAR file with .com filename inside" \
       "ET MALWARE Searchmeup Spyware Install " \
       "ET MALWARE Trafficsector.com Spyware Install" \
       "ET MALWARE Winfixmaster.com Fake Anti-Spyware Install" \
       "ET MALWARE Possible Windows executable sent when remote host claims to send a Text File" \
       "ET MALWARE W32/InstallRex.Adware Initial CnC Beacon" \
       "ET MOBILE_MALWARE Android.Adware.Wapsx.A" \
       "GPL NETBIOS SMB InitiateSystemShutdown unicode little endian andx attempt" \
       "GPL NETBIOS SMB IrotIsRunning unicode attempt" \
       "ET P2P Libtorrent User-Agent" \
       "ET POLICY CCProxy in use remotely - Possibly Hostile/Malware" \
       "ET POLICY URL Contains passphrase Parameter" \
       "GPL POP3 POP3 PASS overflow attempt" \
       "ET SCAN Cisco Torch IOS HTTP Scan" \
       "GPL SCAN nmap fingerprint attempt" \
       "GPL SHELLCODE x86 0x90 unicode NOOP" \
       "GPL SQL dbms_repcat.comment_on_site_priority buffer overflow attempt" \
       "ET TOR Known Tor Exit Node UDP Traffic group 6" \
       "ET TOR Known Tor Exit Node UDP Traffic group 106" \
       "ET TOR Known Tor Relay/Router " \
       "ET TOR Known Tor Relay/Router " \
       "ET TOR Known Tor Relay/Router " \
       "ET TOR Known Tor Relay/Router " \
       "ET TOR Known Tor Relay/Router " \
       "ET TROJAN IRC Potential DDoS command 1" \
       "ET TROJAN User-agent DownloadNetFile Win32.small.hsh downloader" \
       "ET TROJAN Zalupko/Koceg/Mandaph manda.php Checkin" \
       "ET TROJAN Vundo Variant reporting to Controller via HTTP " \
       "ET TROJAN Syrutrk/Gibon/Bredolab Checkin" \
       "ET TROJAN Hiloti loader installed successfully response" \
       "ET TROJAN Spyeye Data Exfiltration 6" \
       "ET TROJAN Backdoor Win32.Idicaf/Atraps" \
       "ET TROJAN Mirage Campaign checkin" \
       "ET TROJAN Dorkbot Loader Payload Request" \
       "ET TROJAN Drive DDoS Tool byte command received key=okokokjjk" \
       "ET TROJAN Possible Mask C2 Traffic" \
       "ET TROJAN Citadel Checkin" \
       "ET TROJAN ABUSE.CH SSL Blacklist Malicious SSL certificate detected " \
       "ET WEB_CLIENT Foxit PDF Reader Title Stack Overflow" \
       "ET WEB_SERVER Possible INSERT INTO SQL Injection In Cookie" \
       "ET WEB_SERVER SQL Errors in HTTP 200 Response " \
       "GPL WEB_SERVER perl command attempt" \
       "ET WEB_SPECIFIC_APPS E-Annu SQL Injection Attempt -- home.php a ASCII" \
       "ET WEB_SPECIFIC_APPS ol bookmarks SQL Injection Attempt -- index.php id DELETE" \
       "ET WEB_SPECIFIC_APPS phpx SQL Injection Attempt -- users.php user_id DELETE" \
       "ET WEB_SPECIFIC_APPS Mambo SQL Injection Attempt -- moscomment.php mcname SELECT" \
       "ET WEB_SPECIFIC_APPS Kartli Alisveris Sistemi SQL Injection Attempt -- news.asp news_id INSERT" \
       "ET WEB_SPECIFIC_APPS XLAtunes SQL Injection Attempt -- view.php album INSERT" \
       "ET WEB_SPECIFIC_APPS Hunkaray Duyuru Scripti SQL Injection Attempt -- oku.asp id ASCII" \
       "ET WEB_SPECIFIC_APPS Easebay Resources Paypal Subscription Manager SQL Injection Attempt -- memberlist.php keyword DELETE" \
       "ET WEB_SPECIFIC_APPS Francisco Burzi PHP-Nuke SQL Injection Attempt -- index.php position DELETE" \
       "ET WEB_SPECIFIC_APPS Rialto SQL Injection Attempt -- listfull.asp ID UPDATE" \
       "ET WEB_SPECIFIC_APPS PHP-Update SQL Injection Attempt -- guestadd.php newmessage SELECT" \
       "ET WEB_SPECIFIC_APPS DMXReady Secure Login Manager SQL Injection Attempt -- login.asp sent INSERT" \
       "ET WEB_SPECIFIC_APPS VerliAdmin SQL Injection Attempt -- verify.php nick_mod ASCII" \
       "ET WEB_SPECIFIC_APPS Novell ZENworks Patch Management " \
       "ET WEB_SPECIFIC_APPS Expinion.net iNews SQL Injection Attempt -- articles.asp ex INSERT" \
       "ET WEB_SPECIFIC_APPS Enthrallweb eClassifieds SQL Injection Attempt -- dircat.asp cid ASCII" \
       "ET WEB_SPECIFIC_APPS ClickTech ClickContact SQL Injection Attempt -- default.asp In UNION SELECT" \
       "ET WEB_SPECIFIC_APPS ActiveNews Manager SQL Injection Attempt -- activenews_view.asp articleID INSERT" \
       "ET WEB_SPECIFIC_APPS ccTiddly include.php cct_base parameter Remote File Inclusion" \
       "ET WEB_SPECIFIC_APPS Hubscript PHPInfo Attempt" \
       "ET WEB_SPECIFIC_APPS SERWeb main_prepend.php functionsdir Parameter Remote File Inclusion" \
       "ET WEB_SPECIFIC_APPS phpBB3 Brute-Force reg attempt " \
       "ET WEB_SPECIFIC_APPS Possible JBoss JMX Console Beanshell Deployer WAR Upload and Deployment Exploit Attempt" \
       "ET WEB_SPECIFIC_APPS Woltlab Burning Board katid Parameter UPDATE SET SQL Injection Attempt" \
       "ET WEB_SPECIFIC_APPS TCExam tce_xml_user_results.php script UPDATE SET SQL Injection Attempt" \
       "ET WEB_SPECIFIC_APPS b2evolution skins_path Parameter Remote File inclusion Attempt" \
       "ET WEB_SPECIFIC_APPS WordPress Gallery Plugin filename_1 Parameter Remote File Access Attempt") 

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
  
  thisHost="${hostName[$(($RANDOM % ${#hostName[@]} +1 ))]}"

  # Get value to increment epoch
  incrementTime="${genTime[$(($RANDOM % ${#genTime[@]} +1 ))]}"

  # Add epoch + value of incrementTime
  newTimeEpoch=$((incrementTime + getTime))

  # Take the new epoch value and put it in Apache log format
  newTime=$(date -r $newTimeEpoch "+%m/%d/%Y:%H:%M:%S")

  echo -e "${newTime} ${sensorIP} Alert:[$((1 + $((RANDOM))))] \"${etMsg[$(($RANDOM % ${#etMsg[@]} +1 ))]}\" [IMPACT] from ${thisHost} at ${newTime} [Classification: ${snortAlerts[$(($RANDOM % ${#snortAlerts[@]} +1 ))]} [Priority: $((1 + $((RANDOM % 4))))] ${protType[$(($RANDOM % ${#protType[@]} +1 ))]} ${srcIP} -> ${sensorIP}:$((1025 + $((RANDOM % 65535))))" >> ~/Desktop/log-gen/snort.log

  let getTime="${newTimeEpoch}"

  unset -f "${hostName[*]}"
  unset -f "${protType[*]}"
  unset -f "${snortAlerts[*]}"
  unset -f "${etMsg[*]}"
  unset -f "${genIP[*]}"
  unset -f "${srcIP[*]}"
  unset -f "${thisHost[*]}"
  break

done

}


syslog_create () {

directory_name=~/Desktop/log-gen
srcPort=$((1024 + $((RANDOM % 65535))))
userName=("jtbowers" "smcappo" "plmarro" "ttarcol" "mstewart" "root" "kdorsey" "dvargas" "thoerger" "rreichert" "dulmer")
hostName=("adv-win2k16-dns" "adv-win2k16-dc" "adv-win2k16-ad" "adv-win2k16-iis" "adv-win2k16-sql" "adv-win2k16-cv" "adv-win2k16-dc1" "adv-win2k16-dc2" "adv-win2k16-dc3")
thisHost="${hostName[$(($RANDOM % ${#hostName[@]} +1 ))]}"

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

  # Get value to increment epoch
  incrementTime="${genTime[$(($RANDOM % ${#genTime[@]} +1 ))]}"

  # Add epoch + value of incrementTime
  newTimeEpoch=$((incrementTime + getTime))

  # Take the new epoch value and put it in Apache log format
  newTime=$(date -r $newTimeEpoch "+%m/%d/%Y:%H:%M:%S")

  randPid="$((2000 + $((RANDOM % 65536))))"
  user="${userName[$RANDOM % ${#userName[@]}]}"
  syslogMsgs=("${newTime} ${thisHost} sshd[${randPid}]: Accepted password for ${user} from  ${srcIP} port ${srcPort} ssh2" \
              "${newTime} ${thisHost} sshd[${randPid}]: Accepted publickey for ${user} from  ${srcIP} port ${srcPort} ssh2\n${newTime} ${thisHost} ${serv}[${randPid}]: subsystem request for sftp" \
              "${newTime} ${thisHost} sshd[${randPid}]: Failed non for illegal user ${user} from ${srcIP} port ${srcPort} ssh2\n${newTime} ${thisHost} sshd[${randPid}]: Failed keyboard-interactive for illegal user ${userName[$RANDOM % ${#userName[@]}]} from ${srcIP} port ${srcPort} ssh2" \
              "${newTime} ${thisHost} sshd[${randPid}]: pam_unix(sshd:session): session opened for user ${user} by (uid=0)" \
              "${newTime} ${thisHost} sshd[${randPid}]: Disconnecting: Too many authentication failures for ${user}" \
              "${newTime} ${thisHost} CROND[${randPid}]: (cronjob) CMD (/usr/local/bin/sysCheck.sh)" \
              "${newTime} ${thisHost} CROND[${randPid}]: (cronjob) CMD (/etc/cron.hourly/watchdog)" \
              "${newTime} ${thisHost} CROND[${randPid}]: (cronjob) CMD (/etc/cron.hourly/cleanLog.sh)" \
              "${newTime} ${thisHost} avahi-autoipd(eth0)[${randPid}]: Found user 'avahi-autoipd' (UID 105) and group 'avahi-autoipd' (GID 117)." \
              "${newTime} ${thisHost} avahi-autoipd(eth0)[${randPid}]: Successfully called chroot()." \
              "${newTime} ${thisHost} avahi-autoipd(eth0)[${randPid}]: Successfully dropped root privileges." \
              "${newTime} ${thisHost} ntpd[${randPid}]: Deleting interface #3 eth0, ${srcIP}#123, interface stats: received=278, sent=322, dropped=0, active_time=8505 secs" \
              "${newTime} ${thisHost} ntpd[${randPid}]: 91.189.89.199 interface ${srcIP} -> (none)" \
              "${newTime} ${thisHost} ntpd[${randPid}]: 74.91.27.139 interface ${srcIP} -> (none)" \
              "${newTime} ${thisHost} ntpd[${randPid}]: 72.20.40.62 interface ${srcIP} -> (none)" \
              "${newTime} ${thisHost} /etc/mysql/debian-start${randPid}]: Looking for 'mysqlcheck' as: /usr/bin/mysqlcheck" \
              "${newTime} ${thisHost} /etc/mysql/debian-start[${randPid}]: Looking for 'mysql' as: /usr/bin/mysql" \
              "${newTime} ${thisHost} /etc/mysql/debian-start[${randPid}]: This installation of MySQL is already upgraded to 5.5.43, use --force if you still need to run mysql_upgrade" \
              "${newTime} ${thisHost} /etc/mysql/debian-start[${randPid}]: Checking for insecure root accounts." \
              "${newTime} ${thisHost} anacron[${randPid}]: Normal exit (0 jobs run)")

  echo -e "${syslogMsgs[$(($RANDOM % ${#syslogMsgs[@]} +1 ))]}" >> ~/Desktop/log-gen/syslog.log

  let getTime="${newTimeEpoch}"

  unset -f "${hostName[*]}"
  unset -f "${userName[*]}"
  unset -f "${thisHost[*]}"
  unset -f "${genIP[*]}"
  unset -f "${srcIP[*]}"
  unset -f "${srcPort[*]}"
  unset -f "${thisHost[*]}"
  unset -f "${randPid[*]}"
  unset -f "${user[*]}"
  unset -f "${syslogMsgs[*]}"
  break

done

}


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
  osseclog_create
  netflowlog_create
  snortlog_create
  syslog_create
  httplog_create
  iptablelog_create
done