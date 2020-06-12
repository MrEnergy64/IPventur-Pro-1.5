#! /bin/bash
# IPventur-Pro.sh
# benötigt root rechte, sowie fping und nmap
# updated: 12.06.2020 MrEnergy64 origin: Linux-User
# Version: 1.4c
#
clear
# füge das zu überprüfende Netzwerk hinzu
echo ""
echo "*****************************"
echo -e "* \e[44mIPventur-Deutsch Pro 1.4c\e[49m *"
echo "*****************************"
echo ""
# Überprüfe ob fping und nmap vorhanden ist
echo 
command -v fping >/dev/null 2>&1 || { echo -e >&2 "Programm \e[40m\e[33mfping\e[49m\e[39m ist nicht installiert!  Bitte installieren."; exit 1; }
echo -e "Programm \e[40m\e[33mfping\e[49m\e[39m ist vorhanden!"
echo
command -v nmap >/dev/null 2>&1 || { echo -e >&2 "Programm \e[40m\e[33mnmap\e[49m\e[39m ist nicht installiert!  Bitte installieren."; exit 1; }
echo -e "Programm \e[40m\e[33mnmap\e[49m\e[39m  ist vorhanden!"

echo ""
echo "Welches Netzwerk soll gescannt werden (z.B. 192.168.1.0/24 oder 192.168.111.1/32 [Enter]): "
echo ""
read  netw
# check ob eine IP Adresse vorhanden ist und gültig
if [[ -z $netw ]]; then
	clear; echo ""; echo "Keine IP Adresse vorhanden, starte Script erneut....";sleep 3; exec "./IPventur-ger-pro.sh"
fi
if [[ $netw =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\/[0-9]{1,2}$ ]]; then
	clear; echo ""; echo -e " \e[40m\e[33mValide IP Adresse\e[49m\e[39m "
else
	clear;  echo ""; echo "$netw ist keine valide IP Adresse/Subnet mask, starte script erneut....";sleep 3; exec "./IPventur-ger-pro.sh"
fi
# Menü für Parameterübergabe an NMAP
echo ""
echo "*****************************"
echo -e "* \e[44mIPventur-Deutsch Pro 1.4c\e[49m *"
echo "*****************************"
echo ""
echo -e "Scanne Netzwerk: \e[40m\e[33m$netw\e[49m\e[39m "
echo ""
echo "wählen Sie eine NMAP Scan Version aus (1,2,3,4,5,6,7 [Enter]): "
echo ""
echo -e "  \e[40m\e[33m1)\e[49m\e[39m NMAP -A 			(intensiver Scan mit OS/Service Version (1000 ports), Traceroute etc.)"
echo -e "  \e[40m\e[33m2)\e[49m\e[39m NMAP -v -A -p1-65535	(größere Ausführlichkeit, intensiver Scan, alle Ports)"
echo -e "  \e[40m\e[33m3)\e[49m\e[39m NMAP -6 			(Standard Scan mit IPv6)"
echo -e "  \e[40m\e[33m4)\e[49m\e[39m NMAP -F -T5 		(schnellster Scan, aber nur Standard Ports)"
echo -e "  \e[40m\e[33m5)\e[49m\e[39m NMAP ohne Parameter 	(Standard Scan mit offenen Ports)"
echo -e "  \e[40m\e[33m6)\e[49m\e[39m NMAP -d9			(Debug mit höster Stufe, kann sehr lange dauern!)"
echo -e "  \e[40m\e[33m7)\e[49m\e[39m NMAP -sV --script 		(Scanne mit Script)"
echo "				(Check wo die Scripts liegen (locate *.nse): ~/.nmap/scripts oder /usr/share/nmap/scripts)"
echo "				(Update neue NSE NMAP Scripts: sudo nmap --script-updatedb)"
echo ""
read n
clear
echo ""
case $n in
# hier können die nmap Parameter geändert werden
  1) echo " Auswahl: NMAP -A"; AUSWAHL="nmap -A";;
  2) echo " Auswahl: NMAP -v -A -p1-65535"; AUSWAHL="nmap -v -A -p1-65535";;
  3) echo " Auswahl: NMAP -6"; AUSWAHL="nmap -6";;
  4) echo " Auswahl: NMAP -F -T5"; AUSWAHL="nmap -F -T5";;
  5) echo "Auswahl: NMAP"; AUSWAHL="nmap";;
  6) echo "Auswahl: NMAP -d9"; AUSWAHL="nmap -d9";;
  7) echo -e "Auswahl: \e[40m\e[33mNMAP -sv --script\e[49m\e[39m "; echo ""; echo -e "Scanne Netzwerk: \e[40m\e[33m$netw\e[49m\e[39m ";echo "";read -p "Whelches Script soll benutzt werden (z.B vulners etc.)?  => " nms; AUSWAHL="nmap -sV --script $nms";;
  *) echo "ungültige Auswahl, starte Script neu....";sleep 3; exec "./IPventur-ger-pro.sh";;
esac
# Wähle das Ausgabeformat
clear
echo ""
echo "*****************************"
echo -e "* \e[44mIPventur-Deutsch Pro 1.4c\e[49m *"
echo "*****************************"
echo ""
echo -e "Scanne Netzwerk: \e[40m\e[33m$netw\e[49m\e[39m"
echo -e "NMAP Parameter:  \e[40m\e[33m$AUSWAHL\e[49m\e[39m"
echo ""
echo "Wähle ein NMAP Ausgabeformat (1,2,3,4,5 [Enter]): "
echo ""
echo -e "  \e[40m\e[33m1)\e[49m\e[39m -oN 			(Ausgabe Scan in normal)"
echo -e "  \e[40m\e[33m2)\e[49m\e[39m -oS 			(Ausgabe Scan in s|<rIpt kIddi3)"
echo -e "  \e[40m\e[33m3)\e[49m\e[39m -oG 			(Ausgabe Scan im Grepable Format)"
echo -e "  \e[40m\e[33m4)\e[49m\e[39m -oX			(Ausgabe Scan im XML Format, muss aber re-editiert werden)"
echo -e "  \e[40m\e[33m5)\e[49m\e[39m -oA			(Ausgabe Scan in allen Formaten)"
echo ""
echo "Hinweis: es werden zwei Ausgabedateien erstellt (Ausnahme Nr.5): eine mit Standard und eine mit Ihrer Wahl!"
echo ""
read n
echo ""
case $n in
# here you can change the namp output parameters
  1) echo " Auswahl: -oN",; AUSWAHL2="-oN";;
  2) echo " Auswahl: -oS"; AUSWAHL2="-oS";;
  3) echo " Auswahl: -oG"; AUSWAHL2="-oG";;
  4) echo " Auswahl: -oX"; AUSWAHL2="-oX";;
  5) echo " Auswahl: -oA"; AUSWAHL2="-oA";;
  *) echo "ungültige Auswahl, starte Script neu....";sleep 3; exec "./IPventur-ger-pro.sh";;
esac
clear
echo ""
echo "*****************************"
echo -e "* \e[44mIPventur-Deutsch Pro 1.4c\e[49m *"
echo "*****************************"
echo ""
echo ""
echo -e "Scanne Netzwerk: 	\e[40m\e[33m$netw\e[49m\e[39m "
echo -e "NMAP Parameter: 	\e[40m\e[33m$AUSWAHL\e[49m\e[39m "
echo -e "Ausgabeformat:		\e[40m\e[33m$AUSWAHL2\e[49m\e[39m "
echo ""
echo "Übersicht aktiver Netzwerkteilnehmer:"
echo "(für MAC Adressen: als root/sudo im selben Netzwerk starten)"
echo "------------------------------------------------------------"
echo
echo
# aktuelles Startdatum und Uhrzeit wird der Ausgangsdatei hinzugefügt
datum=$(date +%d.%m.%Y-%H:%M:%S)
datum2=$(date +%d%m%Y)
echo -e "Start: 	   \e[40m\e[33m$datum\e[49m\e[39m "
echo -e "Kommando:  \e[40m\e[33m$AUSWAHL $AUSWAHL2 $netw\e[49m\e[39m "
netz2=$(echo $netw | cut -d "/" -f 1)
netz=$netz2
echo Start: $datum > lanliste-$netz-$datum2.txt
echo Kommando: $AUSWAHL $AUSWAHL2 $netw >> lanliste-$netz-$datum2.txt
echo ""
# Beginn Ergebnisdatei
echo "------------------------------------------------------------" >> lanliste-$netz-$datum2.txt
echo "Netzwerkbestand $datum / $netw" > lanliste-$netz-$datum2.txt
echo "------------------------------------------------------------" >> lanliste-$netz-$datum2.txt
echo "------------------------------------------------------------"
echo "" >> lanliste-$netz-$datum2.txt
# Scannen des Netztes und Ablage in Ergebnisdatei, fping stellt fest welche IP Online ist
for k in $(fping -aq -g $netw); do
	echo -e "wird untersucht: \e[40m\e[33m$k\e[49m\e[39m "
	echo "Aktiv: $k" >> lanliste-$netz-$datum2.txt
# -n startet IP DNS Namen check und IP Adresse, -sP zeigt IP Adresse mit MAC Adresse und Hersteller ID
	nmap -R -sP $k | awk '/Nmap scan report for/{printf $5" "$6;}/MAC Address:/{print " => "$3" "$4" "$5" "$6;}' | sort >> lanliste-$netz-$datum2.txt
# -A zeigt mehr Informationen wie OS Version, Traceroute, welche Scripts laufen etc.
	$AUSWAHL $k | grep -B1 open >> lanliste-$netz-$datum2.txt
# zweiter nmap command mit gewähltem Ausgabeformat 
	$AUSWAHL $k --append-output $AUSWAHL2 lanliste$AUSWAHL2-$netz-$datum2 >> lanliste-$netz-$datum2.txt
	echo "---------------------------------------------------" >> lanliste-$netz-$datum2.txt
echo >> lanliste-$netz-$datum2.txt
done
echo "-------------------------------------------------------"
echo "                      E N D E" >> lanliste-$netz-$datum2.txt
datum=$(date +%d.%m.%Y-%H:%M:%S)
echo $datum >> lanliste-$netz-$datum2.txt
echo "-------------------------------------------------------" >> lanliste-$netz-$datum2.txt
echo Ende: $datum
echo
# Anzeige Ergebnisdatei
less lanliste-$netz-$datum2.txt
