#! /bin/sh
# IPventur.sh Pro
# recommend root rights, need fping and nmap
# updated: 09.06.2020 MrEnergy64 origin: Linux-User
# Version: 1.2
#
clear
# Add network which you like to scan
echo ""
echo "****************************"
echo "* IPventur-English Pro 1.2 *"
echo "****************************"
echo ""
echo "Which network would you like to scan (e.g. 192.168.1.0/24 [Enter]): "
echo ""
read netw
clear
# Menu to choice nmap parameters
clear
echo ""
echo "****************************"
echo "* IPventur-English Pro 1.2 *"
echo "****************************"
echo ""
echo "Scan Network: $netw"
echo ""
echo "choice NMAP Scan Version (1,2,3,4,5 [Enter]): "
echo ""
echo "  1) NMAP -R -A 		(intensive scan with OS/Service version, traceroute etc. with DNS resolve)"
echo "  2) NMAP -n -A 		(intensive scan with OS/Service version, traceroute etc. without DNS resolve)"
echo "  3) NMAP -6			(standard scan with IPv6)"
echo "  4) NMAP -F -T5		(fastest scan, only some standard ports info)"
echo "  5) NMAP without switches 	(standard scan with open ports)" 
echo ""
read n
clear
echo ""
case $n in
# here you can change the namp parameters
  1) echo " Choice: NMAP -R -A"; CHOICE="nmap -R -A";;
  2) echo " Choice: NMAP -n -A"; CHOICE="nmap -n -A";;
  3) echo " Choice: NMAP -6"; CHOICE="nmap -6";;
  4) echo " Choice: NMAP -F -T5"; CHOICE="nmap -F -T5";;
  5) echo " Choice: NMAP "; CHOICE="nmap";;
  *) echo "invalide option, starting script again....";sleep 3; exec "./IPventur-eng-pro.sh";;
esac
# Menu to choice output format
clear
echo ""
echo "****************************"
echo "* IPventur-English Pro 1.2 *"
echo "****************************"
echo ""
echo "Scan Network: $netw"
echo "NMAP Command: $CHOICE"
echo ""
echo "choice NMAP output format (1,2,3,4 [Enter]): "
echo ""
echo "  1) -oN 			(Output scan in normal)"
echo "  2) -oS 			(Output scan in s|<rIpt kIddi3)"
echo "  3) -oG 			(Output scan in grepable format)"
echo ""
echo "Note: you will get two files: normal output and one whith your choice!"
read n
echo ""
case $n in
# here you can change the namp output parameters
  1) echo " Choice: -oN",; CHOICE2="-oX";;
  2) echo " Choice: -oS"; CHOICE2="-oS";;
  3) echo " Choice: -oG"; CHOICE2="-oG";;
  *) echo "invalide option, starting script again....";sleep 3; exec "./IPventur-eng-pro.sh";;
esac
clear
echo "----------------------------------------------------------------"
# check if fping and nmap installed
echo "----------------------------------------------------------------"
echo
command -v fping >/dev/null 2>&1 || { echo >&2 "I require fping but it's not installed.  Please install."; exit 1; }
echo "Program fping is installed!"
echo
command -v nmap >/dev/null 2>&1 || { echo >&2 "I require nmap but it's not installed.  Please install."; exit 1; }
echo "Program nmap is installed!"
echo ""
echo "Scan Network:  $netw"
echo "NMAP Command:  $CHOICE"
echo "Output Format: $CHOICE2"
echo ""
echo "Overview active network systems:"
echo "(to get MAC addresses, you must be in the same net as root/sudo)"
echo "----------------------------------------------------------------"
echo
date2=$(date +%d.%m.%Y-%H:%M:%S)
date3=$(date +%d%m%Y)
echo Start: $date2 $CHOICE $CHOICE2 Net/IP = $netw
echo
net2=$(echo $netw | cut -d "/" -f 1)
netO=$net2
echo Start: $date2 $CHOICE $CHOICE2 Net/IP = $netw > lanlist-$netO-$date3.txt
echo ""
# Begin creation output file
echo "----------------------------------------------------------------" >> lanlist-$netO-$date3.txt
echo "Network items $date2 / $netw" > lanlist$CHOICE2-$netO-$date3.txt
echo "----------------------------------------------------------------" >> lanlist-$netO-$date3.txt
echo "----------------------------------------------------------------"
echo ""  >> lanlist-$netO-$date3.txt
# Scan network and log to the output file, fping checks online IP's only
for k in $(fping -aq -g $netw); do
	echo "scanning...: $k"
	echo "Online: $k" >> lanlist-$netO-$date3.txt
# -n Never do DNS resolution resolve, -sP check if IP up and give MAC address with Vendor
	nmap -n -sP $k | awk '/Nmap scan report for/{printf $5;}/MAC Address:/{print " => "$3" "$4" "$5;}' | sort >> lanlist-$netO-$date3.txt
# second nmap command with your choiced parameters
	$CHOICE $k | grep -B1 open >> lanlist-$netO-$date3.txt
# now with your choiced output format
	$CHOICE $k --append-output $CHOICE2 lanlist$CHOICE2-$netO-$date3 | grep -B1 open >> lanlist-$netO-$date3.txt
echo "----------------------------------------------------------------" >> lanlist-$netO-$date3.txt
done
echo "----------------------------------------------------------------"
echo "                            E N D" >> lanlist-$netO-$date3.txt
echo
date2=$(date +%d.%m.%Y-%H:%M:%S)
echo $date2 >> lanlist-$netO-$date3.txt
echo "----------------------------------------------------------------" >> lanlist-$netO-$date3.txt
echo End: $date2
echo 
# Display output file
less lanlist-$netO-$date3.txt
