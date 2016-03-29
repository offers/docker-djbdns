#!/bin/sh 
set -e

#
# Setup djbdns as a network cache: http://cr.yp.to/djbdns/run-cache-x.html
#
useradd Gdnscache && useradd Gdnslog
dnscache-conf Gdnscache Gdnslog /etc/dnscache 0.0.0.0

# Allow only private networks to access the DNS server
touch /etc/dnscache/root/ip/10
for i in `seq 16 31`; do touch /etc/dnscache/root/ip/172.$i; done
touch /etc/dnscache/root/ip/192.168

# Run dnscache only as a forwarder
echo 1 > /etc/dnscache/env/FORWARDONLY

# Put the contents of /etc/resolv.conf into the dnscache server list
/usr/local/bin/migrate_resolvconf.py

# Disable logging by having multilog throw away logs
echo "#!/bin/sh\nexec setuidgid bin multilog -*" > /etc/dnscache/log/run

# my_init will run the service
ln -s /etc/dnscache /etc/service/dnscache
