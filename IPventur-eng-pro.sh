#! /bin/sh
# IPventur.sh
# need root rights, fping and nmap
# updated: 08.06.2020 MrEnergy64 origin: Linux-User
# Version: 0.6
#
# Start without parameter - exit
clear
if [ -z $1 ]; then
	echo 
	echo "NETWORK/CIDR (e.g. 192.168.0.0/24) is needed!"
	echo "(Example: sudo ./IPventur-eng-06.sh 10.0.0.0/23 [Enter])"
	exit
fi
clear
# Menu to choice nmap parameters
clear
echo ""
echo "* IPventur-English Pro 1.0 *"
echo "****************************"
echo ""
echo " choice NMAP Scan Version (1,2,3,4 [Enter]): "
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
echo Start: $date2 $CHOICE Net/IP = $1
echo
net2=$(echo $1 | cut -d "/" -f 1)
netO=$net2
# Begin creation output file
echo "Network items $datum / $1" > lanlist-$netO-$date3.txt
echo "--------------------------------------------------------------" >> lanlist-$netO-$date3.txt
echo "--------------------------------------------------------------"

# Scan network and log to the output file, fping checks online IP's only
for k in $(fping -aq -g $1); do
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
datum=$(date +%d.%m.%Y-%H:%M:%S)
echo $date2 >> lanlist-$netO-$date3.txt
echo "-------------------------------------------------------" >> lanlist-$netO-$date3.txt
echo End: $date2
echo 
# Display output file
less lanlist-$netO-$date3.txt
