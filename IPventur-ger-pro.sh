#! /bin/sh
# IPventur-Pro.sh
# benötigt root rechte, sowie fping und nmap
# updated: 08.06.2020 MrEnergy64 origin: Linux-User
# Version: 1.1
#
clear
# füge das zu überprüfende Netzwerk hinzu
echo ""
echo "****************************"
echo "* IPventur-Deutsch Pro 1.1 *"
echo "****************************"
echo ""
echo "Welches Netzwerk soll gescannt werden (z.B. 192.168.1.0/24 [Enter]): "
echo ""
read netw
# Menü für Parameterübergabe an NMAP
clear
echo ""
echo " Scan Netzwerk: $netw"
echo ""
echo "****************************"
echo "* IPventur-Deutsch Pro 1.1 *"
echo "****************************"
echo ""
echo " wählen Sie eine NMAP Scan Version aus (1,2,3,4 [Enter]): "
echo ""
echo "  1) NMAP -A 			(intensiver Scan mit OS/Service Version, Traceroute etc. mit DNS Auflöung)"
echo "  2) NMAP -n -A 		(intensiver Scan mit OS/Service Version, Traceroute etc. ohne DNS Auflöung)"
echo "  3) NMAP -6 			(Standard Scan mit IPv6)"
echo "  4) NMAP -F -T5 		(schnellster Scan, aber nur Standard Ports)"
echo "  5) NMAP ohne Parameter 	(Standard Scan mit offenen Ports)" 
echo ""
read n
clear
echo ""
case $n in
# hier können die nmap Parameter geändert werden
  1) echo " Auswahl: NMAP -A"; AUSWAHL="nmap -A";;
  2) echo " Auswahl: NMAP -n -A"; AUSWAHL="nmap -n -A";;
  3) echo " Auswahl: NMAP -6"; AUSWAHL="nmap -6";;
  4) echo " Auswahl: NMAP -F -T5"; AUSWAHL="nmap -F -T5";;
  5) echo "Auswahl: NMAP "; AUSWAHL="nmap";;
  *) echo "ungültige option, beende Script"; exit;;
esac
echo "-------------------------------------------------------"
# Check for fping and nmap
echo "-------------------------------------------------------"
echo
command -v fping >/dev/null 2>&1 || { echo >&2 "fping ist nicht installiert!  Bitte installieren."; exit 1; }
echo "Programm fping ist vorhanden!"
echo
command -v nmap >/dev/null 2>&1 || { echo >&2 "nmap ist nicht installiert!  Bitte installieren."; exit 1; }
echo "Programm nmap ist vorhanden!"
echo 
echo
echo "Übersicht aktiver Netzwerkteilnehmer:"
echo "(für MAC Adressen: als root/sudo im selben Netzwerk starten)"
echo "------------------------------------------------------------"
echo
echo
# aktuelles Startdatum und Uhrzeit wird der Ausgangsdatei hinzugefügt
datum=$(date +%d.%m.%Y-%H:%M:%S)
datum2=$(date +%d%m%Y)
echo Start: $datum $AUSWAHL Netz/IP = $netw
netz2=$(echo $netw | cut -d "/" -f 1)
netz=$netz2
echo
# Beginn Ergebnisdatei
echo "-------------------------------------------------------" > lanliste-$netz-$datum2.txt
echo "Netzwerkbestand $datum / $netw" > lanliste-$netz-$datum2.txt
echo "-------------------------------------------------------" >> lanliste-$netz-$datum2.txt
echo "-------------------------------------------------------"

# Scannen des Netztes und Ablage in Ergebnisdatei, fping stellt fest welche IP Online ist
for k in $(fping -aq -g $netw); do
	echo "wird untersucht: $k"
	echo "Aktiv: $k" >> lanliste-$netz-$datum2.txt
# -n startet kein IP DNS Namen check (nur IP Adresse), -sP zeigt IP Adresse mit MAC Adresse und Hersteller ID
	nmap -n -sP $k | awk '/Nmap scan report for/{printf $5;}/MAC Address:/{print " => "$3" "$4" "$5;}' | sort >> lanliste-$netz-$datum2.txt
# -A zeigt mehr Informationen wie OS Version, Traceroute, welche Scripts laufen etc.
	$AUSWAHL $k | grep -B1 open >> lanliste-$netz-$datum2.txt
	echo "---------------------------------------------------" >> lanliste-$netz-$datum2.txt
echo >> lanliste-$netz-$datum2.txt
done
echo "-------------------------------------------------------"
echo "              E N D E" >> lanliste-$netz-$datum2.txt
datum=$(date +%d.%m.%Y-%H:%M:%S)
echo $datum >> lanliste-$netz-$datum2.txt
echo "-------------------------------------------------------" >> lanliste-$netz-$datum2.txt
echo Ende: $datum
echo
# Anzeige Ergebnisdatei
less lanliste-$netz-$datum2.txt
