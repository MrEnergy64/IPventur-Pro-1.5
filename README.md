# IPventur-Pro-1.4c

famous little IPventur-basic.sh tool, now with menu to choice nmap parameters incl. script, asking for the scan network and the various output files include scanned network and scanned date

1. download script file IPventur-eng-pro.sh (english version) or IPventur-ger-pro.sh (german version)
2. chmod +x IPventur-eng-pro.sh (or chmod +x IPventur-ger-pro.sh)
3. start script with ./IPventur-eng-pro.sh or when you would like to get the MAC addresses:
   sudo ./IPventur-eng-pro.sh
4. the script is asking for the scanning network now  (don't forget a given subnet mask!)
5. if you would like to use the script parameter, give the correct script name (update your script first with sudo nmap --script-updatedb)
6. check output file e.g.: lanlist-10.0.1.0-08062020.txt  (date format is day month year) and formated file like lanlist-oG-10.0.1.0-08062020.txt or when you used -oA you will get more output files with extentions like .xml, nmap or gnmap.

Feel free to change the nmap script parameters, with your own wishes/needs!


Happy collecting.

MrEnergy64

