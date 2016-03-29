# Author: Chris Kite
#
# https://www.github.com/offers/docker-djbdns
#

FROM phusion/baseimage:0.9.18

ENV TERM xterm-256color
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8

ADD . /network-dns-cache

RUN /network-dns-cache/build-djbdns.sh \
    && /network-dns-cache/cleanup.sh
