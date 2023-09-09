# Install Bind DNS Server on Ubuntu
apt-get install bind9 bind9utils bind9-dnsutils bind9-doc bind9-host -y
systemctl start named
systemctl enable named

# How to Manage Bind Services
# Configure Bind DNS Server
nano /etc/bind/named.conf.options

tee /etc/bind/named.conf.options <<EOF
forwarders {
    8.8.8.8;
}
EOF

tee /etc/bind/named.conf.local <<EOF
# forward zone
zone "mydomain.com" {
    type master;
    file "https://net.cloudinfrastructureservices.co.uk/etc/bind/forward.mydomain.com";
};

# reverse zone
zone "0.16.172.in-addr.arpa" {
    type master;
    file "https://net.cloudinfrastructureservices.co.uk/etc/bind/reverse.mydomain.com";
};
EOF

cd /etc/bind/
cp db.127 reverse.mydomain.com
cp db.local forward.mydomain.com

# 172.16.0.10: IP address of DNS server.
# NS: Name server record.
# A: Address record.
# SOA: Start of authority record.
tee /etc/bind/forward.mydomain.com <<EOF
$TTL    604800
@       IN      SOA     nameserver.mydomain.com. root.nameserver.mydomain.com. (
                              2         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
@       IN      NS      nameserver.mydomain.com.
nameserver    IN      A       172.16.0.10
www     IN      A       172.16.0.10
@       IN      AAAA    ::1
EOF

tee /etc/bind/reverse.mydomain.com <<EOF
$TTL    604800
@       IN      SOA     nameserver.mydomain.com. root.nameserver.mydomain.com. (
                              1
                         604800
                          86400
                        2419200
                         604800 )
@       IN      NS      nameserver.mydomain.com.
nameserver    IN      A       172.16.0.10
10       IN      PTR     nameserver.mydomain.com.
EOF

# https://cloudinfrastructureservices.co.uk/how-to-install-bind-dns-on-ubuntu-20-04-server-setup-configure/