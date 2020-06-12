#! /bin/bash
# IPventur.sh Pro
# recommend root rights, need fping and nmap
# updated: 12.06.2020 MrEnergy64 origin: Linux-User
# Version: 1.4c
#
clear
# Add network which you like to scan
echo ""
echo "*****************************"
echo -e "* \e[44mIPventur-English Pro 1.4c\e[49m *"
echo "*****************************"
echo ""
# check if fping and nmap installed
command -v fping >/dev/null 2>&1 || { echo -e >&2 "I require \e[40m\e[33mfping\e[49m\e[39m but it's not installed.  Please install."; exit 1; }
echo -e "Program \e[40m\e[33mfping\e[49m\e[39m is installed!"
echo
command -v nmap >/dev/null 2>&1 || { echo -e >&2 "I require \e[40m\e[33mnmap\e[49m\e[39m but it's not installed.  Please install."; exit 1; }
echo -e "Program \e[40m\e[33mnmap\e[49m\e[39m  is installed!"
echo ""
echo ""
echo "Which network would you like to scan (e.g. 192.168.1.0/24 or 10.0.0.1/32 [Enter]): "
echo ""
read netw
# check if entered IP exist and valid
if [[ -z $netw ]]; then
	clear; echo ""; echo "no IP address, starting script again....";sleep 3; exec "./IPventur-eng-pro.sh"
fi
if [[ $netw =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\/[0-9]{1,2}$ ]]; then
	clear; echo ""; echo "Valid IP address"
else
	clear;  echo ""; echo "$netw is not a valid IP address/subnet mask, starting script again....";sleep 3; exec "./IPventur-eng-pro.sh"
fi
# Menu to choice nmap parameters
echo ""
echo "*****************************"
echo -e "* \e[44mIPventur-English Pro 1.4c\e[49m *"
echo "*****************************"
echo ""
echo -e "Scan Network: \e[40m\e[33m$netw\e[49m\e[39m "
echo ""
echo "choice NMAP Scan Version (1,2,3,4,5,6,7 [Enter]): "
echo ""
echo -e "  \e[40m\e[33m1)\e[49m\e[39m NMAP -A 			(intensive scan with OS/Service version 1000 ports), traceroute etc.)"
echo -e "  \e[40m\e[33m2)\e[49m\e[39m NMAP -v -A -p1-65535	(intensive scan with OS/Service version, traceroute etc. more details and all ports)"
echo -e "  \e[40m\e[33m3)\e[49m\e[39m NMAP -6			(standard scan with IPv6)"
echo -e "  \e[40m\e[33m4)\e[49m\e[39m NMAP -F -T5		(fast scan, some standard ports only)"
echo -e "  \e[40m\e[33m5)\e[49m\e[39m NMAP without switches 	(standard scan with open ports)"
echo -e "  \e[40m\e[33m6)\e[49m\e[39m NMAP -d9			(debug scan with highest, could be very long scan!)"
echo -e "  \e[40m\e[33m7)\e[49m\e[39m NMAP -sV --script 		(scan with your entered script)"
echo "				(Check where your scripts are (locate *.nse): ~/.nmap/scripts or /usr/share/nmap/scripts)"
echo "				(Update new NSE NMAP scripts: sudo nmap --script-updatedb)"
echo ""
read n
clear
echo ""
case $n in
# here you can change the namp parameters
  1) echo "Choice: NMAP -A"; CHOICE="nmap -A";;
  2) echo "Choice: NMAP -v -A -p1-65535"; CHOICE="nmap -v -A -p1-65535";;
  3) echo "Choice: NMAP -6"; CHOICE="nmap -6";;
  4) echo "Choice: NMAP -F -R"; CHOICE="nmap -F -R";;
  5) echo "Choice: NMAP"; CHOICE="nmap";;
  6) echo "Choice: NMAP -d9"; CHOICE="nmap -d9";;
  7) echo -e "Choice: \e[40m\e[33m$NMAP -sv --script\e[49m\e[39m "; echo ""; echo -e "Scan Network: \e[40m\e[33m$netw\e[49m\e[39m ";echo "";read -p "Which script would you like to use (type e.g. vulners etc.) => " nms; CHOICE="nmap -sV --script $nms";;
  *) echo "invalide option, starting script again....";sleep 3; exec "./IPventur-eng-pro.sh";;
esac
# Menu to choice output format
clear
echo ""
echo "*****************************"
echo -e "* \e[44mIPventur-English Pro 1.4c\e[49m *"
echo "*****************************"
echo ""
echo -e "Scan Network: \e[40m\e[33m$netw\e[49m\e[39m "
echo -e "NMAP Command: \e[40m\e[33m$CHOICE\e[49m\e[39m "
echo ""
echo "choice NMAP output format (1,2,3,4,5 [Enter]): "
echo ""
echo -e "  \e[40m\e[33m1)\e[49m\e[39m -oN 			(Output scan in normal)"
echo -e "  \e[40m\e[33m2)\e[49m\e[39m -oS 			(Output scan in s|<rIpt kIddi3)"
echo -e "  \e[40m\e[33m3)\e[49m\e[39m -oG 			(Output scan in grepable format)"
echo -e "  \e[40m\e[33m4)\e[49m\e[39m -oX			(Output scan in XML format - need to be re-edit)"
echo -e "  \e[40m\e[33m5)\e[49m\e[39m -oA			(Output scan in all formats)"
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
echo ""
echo "*****************************"
echo -e "* \e[44mIPventur-English Pro 1.4c\e[49m *"
echo "*****************************"
echo
echo -e "Scan Network:  \e[40m\e[33m$netw\e[49m\e[39m "
echo -e "NMAP Command:  \e[40m\e[33m$CHOICE\e[49m\e[39m "
echo -e  "Output Format: \e[40m\e[33m$CHOICE2\e[49m\e[39m "
echo ""
echo "Overview active network systems:"
echo "(to get MAC addresses, you must be in the same net as root/sudo)"
echo "----------------------------------------------------------------"
echo
date2=$(date +%d.%m.%Y-%H:%M:%S)
date3=$(date +%d%m%Y)
echo -e "Start:   \e[40m\e[33m$date2\e[49m\e[39m "
echo -e "Command: \e[40m\e[33m$CHOICE $CHOICE2 $netw\e[49m\e[39m "
echo
net2=$(echo $netw | cut -d "/" -f 1)
netO=$net2
echo Start: $date2 > lanlist-$netO-$date3.txt
echo Command:  $CHOICE $CHOICE2 $netw >> lanlist-$netO-$date3.txt
echo ""
# Begin creation output file
echo "----------------------------------------------------------------" >> lanlist-$netO-$date3.txt
echo "Network items $date2 / $netw" > lanlist-$netO-$date3.txt
echo "----------------------------------------------------------------" >> lanlist-$netO-$date3.txt
echo "----------------------------------------------------------------"
echo ""  >> lanlist-$netO-$date3.txt
# Scan network and log to the output file, fping checks online IP's only
for k in $(fping -aq -g $netw); do
	echo -e "scanning...: \e[40m$k\e[49m\e[39m "
	echo "Online: $k" >> lanlist-$netO-$date3.txt
# -n Never do DNS resolution resolve, -sP check if IP up and give MAC address with Vendor
	nmap -R -sP $k | awk '/Nmap scan report for/{printf $5" "$6;}/MAC Address:/{print " => "$3" "$4" "$5" "$6;}' | sort >> lanlist-$netO-$date3.txt
# second nmap command with your choiced parameters 
	$CHOICE $k | grep -B1 open >> lanlist-$netO-$date3.txt
# now with your choiced output format
	$CHOICE $k --append-output $CHOICE2 lanlist$CHOICE2-$netO-$date3 >> /dev/null
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
