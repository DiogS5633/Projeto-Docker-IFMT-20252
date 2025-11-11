FROM ubuntu:22.04

RUN apt-get update && \
    apt-get install -y isc-dhcp-server && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /var/lib/dhcp && \
    touch /var/lib/dhcp/dhcpd.leases

COPY dhcpd.conf /etc/dhcp/dhcpd.conf

EXPOSE 67/udp

ENTRYPOINT ["/usr/sbin/dhcpd", "-f", "-d", "eth0"]
