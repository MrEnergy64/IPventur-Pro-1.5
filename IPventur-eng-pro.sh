#! /bin/sh
# IPventur.sh Pro
# recommend root rights, need fping and nmap
# updated: 09.06.2020 MrEnergy64 origin: Linux-User
# Version: 1.3
#
clear
# Add network which you like to scan
echo ""
echo "****************************"
echo "* IPventur-English Pro 1.3 *"
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
echo "* IPventur-English Pro 1.3 *"
echo "****************************"
echo ""
echo "Scan Network: $netw"
echo ""
echo "choice NMAP Scan Version (1,2,3,4,5,6 [Enter]): "
echo ""
echo "  1) NMAP -A 			(intensive scan with OS/Service version 1000 ports), traceroute etc.)"
echo "  2) NMAP -v -A -p1-65535	(intensive scan with OS/Service version, traceroute etc. more details and all ports)"
echo "  3) NMAP -6			(standard scan with IPv6)"
echo "  4) NMAP -F -T5		(fast scan, some standard ports only)"
echo "  5) NMAP without switches 	(standard scan with open ports)"
echo "  6) NMAP -d9			(debug scan with highest, could be very long scan!)"
echo ""
read n
clear
echo ""
case $n in
# here you can change the namp parameters
  1) echo " Choice: NMAP -A"; CHOICE="nmap -A";;
  2) echo " Choice: NMAP -v -A -p1-65535"; CHOICE="nmap -v -A -p1-65535";;
  3) echo " Choice: NMAP -6"; CHOICE="nmap -6";;
  4) echo " Choice: NMAP -F -R"; CHOICE="nmap -F -R";;
  5) echo " Choice: NMAP"; CHOICE="nmap";;
  6) echo " Choice: NMAP -d9"; CHOICE="nmap -d9";;
  *) echo "invalide option, starting script again....";sleep 3; exec "./IPventur-eng-pro.sh";;
esac
# Menu to choice output format
clear
echo ""
echo "****************************"
echo "* IPventur-English Pro 1.3 *"
echo "****************************"
echo ""
echo "Scan Network: $netw"
echo "NMAP Command: $CHOICE"
echo ""
echo "choice NMAP output format (1,2,3,4,5 [Enter]): "
echo ""
echo "  1) -oN 			(Output scan in normal)"
echo "  2) -oS 			(Output scan in s|<rIpt kIddi3)"
echo "  3) -oG 			(Output scan in grepable format)"
echo "  4) -oX			(Output scan in XML format - need to be re-edit)"
echo "  5) -oA			(Output scan in all formats)"
echo ""
echo "Note: you will get two files (except no. 5): normal output and one whith your choice!"
echo ""
read n
echo ""
case $n in
# here you can change the namp output parameters
  1) echo " Choice: -oN"; CHOICE2="-oN";;
  2) echo " Choice: -oS"; CHOICE2="-oS";;
  3) echo " Choice: -oG"; CHOICE2="-oG";;
  4) echo " Choice: -oX"; CHOICE2="-oX";;
  5) echo " Choice: -oX"; CHOICE2="-oA";;
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
	nmap -R -sP $k | awk '/Nmap scan report for/{printf $5" "$6;}/MAC Address:/{print " => "$3" "$4" "$5" "$6;}' | sort >> lanlist-$netO-$date3.txt
# second nmap command with your choiced parameters 
	$CHOICE $k | grep -B1 open >> lanlist-$netO-$date3.txt
# now with your choiced output format
	$CHOICE $k --append-output $CHOICE2 lanlist$CHOICE2-$netO-$date3 >> lanlist-$netO-$date3.txt
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
