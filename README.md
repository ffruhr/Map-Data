# Map-Data

Voraussetzungen: 

alfred: http://downloads.open-mesh.org/batman/stable/sources/alfred/alfred-2014.4.0.tar.gz
alfred-json: https://github.com/tcatm/alfred-json
jq: apt-get install jq
sed: apt-get install sed
nginx: apt-get install nginx

1 - nginx installieren und / oder konfigurieren, z.B. /var/www/ 

2 - status.pl und mkdata.sh auf Gateway downloaden, z.B.:

    wget -O /etc/mkdata.sh https://raw.githubusercontent.com/ffruhr/Map-Data/master/mkdata.sh
    wget -O /etc/fastd/status.pl https://raw.githubusercontent.com/ffruhr/Map-Data/master/status.pl
    chmod +x /etc/mkdata.sh
    chmod +x /etc/fastd/status.pl

2 - Unix Socket im fastd aktivieren - folgende Zeile in alle fastd.conf einfügen:

    status socket "/tmp/fastd.sock";

(2b) - NUR bei mehreren fastd Instanzen pro Gateway entsprechend mit Port benennen und mergen, bspw.:

    fastd.conf Instanz 1: status socket "/tmp/fastd.10000.sock";
    fastd.conf Instanz 2: status socket "/tmp/fastd.10001.sock";
    
    in die /etc/mkdata.sh in diesem Fall den Block fastd Daten ändern in:
    
    /etc/fastd/status.pl /tmp/fastd.10000.sock | jq . | sed -r 's/(\b[0-9]{1,3}\.){3}[0-9]{1,3}\b'/127\.0\.0\.1/ > /tmp/fastd.10000.json
    /etc/fastd/status.pl /tmp/fastd.10001.sock | jq . | sed -r 's/(\b[0-9]{1,3}\.){3}[0-9]{1,3}\b'/127\.0\.0\.1/ > /tmp/fastd.10001.json    
    jq -s '.[0] * .[1]' /tmp/fastd.10000.json /tmp/fastd.10001.json > /var/www/fastd.json

3 - einrichten eines Cron Jobs zur fortlaufenden Aktualisierung

    crontab -e
    */1 * * * * /etc/mkdata.sh

