#!/bin/sh 
set -e

if [ -z "$CACHE_IP" ]; then echo "CACHE_IP is not set" && exit 1; fi

#
# Setup djbdns as a network cache: http://cr.yp.to/djbdns/run-cache-x.html
#
useradd Gdnscache && useradd Gdnslog
dnscache-conf Gdnscache Gdnslog /etc/dnscache $CACHE_IP

# Allow only private networks to access the DNS server
touch /etc/dnscache/root/ip/10
for i in `seq 16 31`; do touch /etc/dnscache/root/ip/172.$i; done
touch /etc/dnscache/root/ip/192.168

# Put the contents of /etc/resolv.conf into the dnscache server list
/usr/local/bin/migrate_resolvconf.py

# Disable logging by having multilog throw away logs
echo "#!/bin/sh\nexec setuidgid bin multilog -*" > /etc/dnscache/log/run

# my_init will run the service
ln -s /etc/dnscache /etc/service/dnscache
