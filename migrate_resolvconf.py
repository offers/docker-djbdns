#!/usr/bin/python3
import re
import os

servers = []
# read nameserver lines out of /etc/resolv.conf
with open('/etc/resolv.conf') as resolv:
    for line in resolv:
        nameserver = re.match(r'nameserver', line)
        if nameserver:
            ip = re.search(r'\b(?:\d{1,3}\.){3}\d{1,3}\b', line)
            if ip:
                addr = ip.group()
                servers.append(addr)

# write nameservers into the djbdns cache config
with open('/etc/dnscache/root/servers/@', 'w') as cache_servers:
    cache_servers.write('\n'.join(servers))
