#! /bin/sh
# IPventur.sh Pro
# need root rights, fping and nmap
# updated: 08.06.2020 MrEnergy64 origin: Linux-User
# Version: 1.1
#
clear
# Add network which you like to scan
echo ""
echo "****************************"
echo "* IPventur-English Pro 1.1 *"
echo "****************************"
echo ""
echo "Which network would you like to scan (e.g. 192.168.1.0/24 [Enter]): "
echo ""
read netw
clear
# Menu to choice nmap parameters
clear
echo ""
echo " Scan Network: $netw"
echo ""
echo "****************************"
echo "* IPventur-English Pro 1.1 *"
echo "****************************"
echo ""
echo " choice NMAP Scan Version (1,2,3,4,5 [Enter]): "
echo ""
echo "  1) NMAP -A 			(intensive scan with OS/Service version, traceroute etc. with DNS resolve)"
echo "  2) NMAP -n -A 		(intensive scan with OS/Service version, traceroute etc. without DNS resolve)"
echo "  3) NMAP -6 			(standard scan with IPv6)"
echo "  4) NMAP -F -T5 		(fastest scan, only some standard ports info)"
echo "  5) NMAP without switches 	(standard scan with open ports)" 
echo ""
read n
clear
echo ""
case $n in
# here you can change the namp parameters
  1) echo " Choice: NMAP -A"; CHOICE="nmap -A";;
  2) echo " Choice: NMAP -n -A"; CHOICE="nmap -n -A";;
  3) echo " Choice: NMAP -6"; CHOICE="nmap -6";;
  4) echo " Choice: NMAP -F -T5"; CHOICE="nmap -F -T5";;
  5) echo " Choice: NMAP "; CHOICE="nmap";;
  *) echo "invalide option, closing script"; exit;;
esac
echo "--------------------------------------------------------------"
# check if fping and nmap installed
echo "--------------------------------------------------------------"
echo
command -v fping >/dev/null 2>&1 || { echo >&2 "I require fping but it's not installed.  Please install."; exit 1; }
echo Program fping is installed!
echo
command -v nmap >/dev/null 2>&1 || { echo >&2 "I require nmap but it's not installed.  Please install."; exit 1; }
echo Program nmap is installed!
echo
echo
echo "Overview active network systems:"
echo "(to get MAC addresses, start the search network as root/sudo)"
echo "--------------------------------------------------------------"
echo
date2=$(date +%d.%m.%Y-%H:%M:%S)
date3=$(date +%d%m%Y)
echo Start: $date2 $CHOICE Net/IP = $netw
echo
net2=$(echo $netw | cut -d "/" -f 1)
netO=$net2
# Begin creation output file
echo "--------------------------------------------------------------" >> lanlist-$netO-$date3.txt
echo "Network items $date2 / $netw" > lanlist-$netO-$date3.txt
echo "--------------------------------------------------------------" >> lanlist-$netO-$date3.txt
echo "--------------------------------------------------------------"

# Scan network and log to the output file, fping checks online IP's only
for k in $(fping -aq -g $netw); do
	echo "scanning...: $k"
	echo "Online: $k" >> lanlist-$netO-$date3.txt
# -n Never do DNS resolution resolve, -sP check if IP up and give MAC address with Vendor
	nmap -n -sP $k | awk '/Nmap scan report for/{printf $5;}/MAC Address:/{print " => "$3" "$4" "$5;}' | sort >> lanlist-$netO-$date3.txt
# -A Enable OS detection, version detection, script scanning, and tracerout, -T<0-5>: Set timing template (higher is faster) 
	$CHOICE $k | grep -B1 open >> lanlist-$netO-$date3.txt
	echo "---------------------------------------------------" >> lanlist-$netO-$date3.txt
done
echo "-------------------------------------------------------"
echo "              E N D" >> lanlist-$netO-$date3.txt
echo
date2=$(date +%d.%m.%Y-%H:%M:%S)
echo $date2 >> lanlist-$netO-$date3.txt
echo "-------------------------------------------------------" >> lanlist-$netO-$date3.txt
echo End: $date2
echo 
# Display output file
less lanlist-$netO-$date3.txt
