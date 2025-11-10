FROM ubuntu:22.04

RUN apt-get update && \
    apt-get install -y isc-dhcp-server && \
    rm -rf /var/lib/apt/lists/*

COPY dhcpd.conf /etc/dhcp/dhcpd.conf

EXPOSE 67/udp

ENTRYPOINT ["/usr/sbin/dhcpd", "-f", "-d"]
