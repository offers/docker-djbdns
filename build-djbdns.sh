#!/bin/bash
set -e

apt-get update \
    && DEBIAN_FRONTEND=noninteractive \
    apt-get --no-install-recommends install -y gcc make linux-libc-dev libc6-dev libc-dev \

#
# Install daemontools: http://cr.yp.to/daemontools/install.html
#
mkdir -p /package && chmod 1755 /package
tar -xzf /network-dns-cache/daemontools-0.76.tar.gz -C /package
cd /package/admin/daemontools-0.76
# patch to compile on linux: http://cr.yp.to/docs/unixport.html#errno
sed -i ' 1 s/.*/& \-include \/usr\/include\/errno.h/' src/conf-cc
./package/install

#
# Install ucspi-tcp: http://cr.yp.to/ucspi-tcp/install.html
#
mkdir -p /src && tar -xzf /network-dns-cache/ucspi-tcp-0.88.tar.gz -C /src/
cd /src/ucspi-tcp-0.88
# patch to compile on linux: http://cr.yp.to/docs/unixport.html#errno
sed -i ' 1 s/.*/& \-include \/usr\/include\/errno.h/' conf-cc
make -j 5 && make setup check

#
# Install djbdns: http://cr.yp.to/djbdns/install.html
#
tar -xzf /network-dns-cache/djbdns-1.05.tar.gz -C /src/
cd /src/djbdns-1.05
echo gcc -O2 -include /usr/include/errno.h > conf-cc
make -j 5 && make setup check

cp /network-dns-cache/migrate_resolvconf.py /usr/local/bin/
cp /network-dns-cache/01_bootstrap_djbdns.sh /etc/my_init.d/
