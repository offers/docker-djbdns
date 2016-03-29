#!/bin/bash
set -e

apt-get remove -y gcc make linux-libc-dev libc6-dev libc-dev \
    && apt-get autoremove -y \
    && apt-get clean

rm -rf /network-dns-cache /src /var/lib/apt/lists/* /tmp/apt-select
