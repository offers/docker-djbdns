# network-dns-cache
Turnkey djbdns network DNS cache

Just start it with port 53/UDP forwarded, point your clients' resolv.conf at it, and voila!

Example:
docker run -p 53:53/udp offers/network-dns-cache:<version>

Allows only clients on a private subnet (i.e. 10., 172.{16-31}, 192.168.) to connect.
