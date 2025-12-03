SKRIP KONFIGURASI FINAL JARKOM MODUL 5

Prefix IP: 192.218.0.0/23

1. NODE: OSGILIATH (Router Pusat)

# === SETUP AWAL: IP & INTERNET ===
ip addr flush dev eth0; ip addr flush dev eth1; ip addr flush dev eth2; ip addr flush dev eth3
echo "nameserver 8.8.8.8" > /etc/resolv.conf

# Internet (Static IP Manual ke NAT GNS3)
ip link set eth0 up
ip addr add 192.168.122.218/24 dev eth0
route add default gw 192.168.122.1

# Install dhclient (Jika koneksi ok)
ping -c 2 8.8.8.8 > /dev/null 2>&1
if [ $? -eq 0 ]; then
    apt-get update -o Acquire::Check-Valid-Until=false -o Acquire::Check-Date=false
    apt-get install isc-dhcp-client -y
fi

# IP Lokal
ip addr add 192.218.1.209/30 dev eth3 && ip link set eth3 up # Minastir
ip addr add 192.218.1.225/30 dev eth1 && ip link set eth1 up # Rivendell
ip addr add 192.218.1.229/30 dev eth2 && ip link set eth2 up # Moria

# === MISI 1: ROUTING ===
echo 1 > /proc/sys/net/ipv4/ip_forward
# Ke Arah Minastir
route add -net 192.218.0.0 netmask 255.255.255.0 gw 192.218.1.210
route add -net 192.218.1.0 netmask 255.255.255.128 gw 192.218.1.210
route add -net 192.218.1.212 netmask 255.255.255.252 gw 192.218.1.210
route add -net 192.218.1.216 netmask 255.255.255.252 gw 192.218.1.210
route add -net 192.218.1.220 netmask 255.255.255.252 gw 192.218.1.210
# Ke Arah Rivendell
route add -net 192.218.1.200 netmask 255.255.255.248 gw 192.218.1.226
# Ke Arah Moria
route add -net 192.218.1.232 netmask 255.255.255.252 gw 192.218.1.230
route add -net 192.218.1.128 netmask 255.255.255.192 gw 192.218.1.230
route add -net 192.218.1.192 netmask 255.255.255.248 gw 192.218.1.230
route add -net 192.218.1.236 netmask 255.255.255.252 gw 192.218.1.230

# === MISI 2: SNAT ===
iptables -t nat -A POSTROUTING -o eth0 -j SNAT --to-source 192.168.122.218


2. NODE: MINASTIR

ip addr flush dev eth0; ip addr flush dev eth1; ip addr flush dev eth2
ip addr add 192.218.1.210/30 dev eth0 && ip link set eth0 up
ip addr add 192.218.0.1/24 dev eth1 && ip link set eth1 up
ip addr add 192.218.1.213/30 dev eth2 && ip link set eth2 up
echo "nameserver 8.8.8.8" > /etc/resolv.conf

echo 1 > /proc/sys/net/ipv4/ip_forward
route add -net 0.0.0.0 netmask 0.0.0.0 gw 192.218.1.209
route add -net 192.218.1.0 netmask 255.255.255.128 gw 192.218.1.214
route add -net 192.218.1.216 netmask 255.255.255.252 gw 192.218.1.214
route add -net 192.218.1.220 netmask 255.255.255.252 gw 192.218.1.214

# Relay (Mode Barbar)
ping -c 1 8.8.8.8 > /dev/null 2>&1
if [ $? -eq 0 ]; then
    rm -rf /var/lib/apt/lists/*
    apt-get update -o Acquire::Check-Valid-Until=false -o Acquire::Check-Date=false --allow-insecure-repositories --allow-releaseinfo-change
    apt-get install isc-dhcp-relay -y --allow-unauthenticated
    [ -f /usr/sbin/dhcrelay ] && /usr/sbin/dhcrelay -i eth0 -i eth1 -i eth2 192.218.1.202
fi


3. NODE: PELARGIR

ip addr add 192.218.1.214/30 dev eth0 && ip link set eth0 up
ip addr add 192.218.1.217/30 dev eth2 && ip link set eth2 up
ip addr add 192.218.1.221/30 dev eth1 && ip link set eth1 up
echo 1 > /proc/sys/net/ipv4/ip_forward
route add -net 0.0.0.0 netmask 0.0.0.0 gw 192.218.1.213
route add -net 192.218.1.0 netmask 255.255.255.128 gw 192.218.1.222


4. NODE: ANDUINBANKS

ip addr flush dev eth0; ip addr flush dev eth1
ip addr add 192.218.1.222/30 dev eth0 && ip link set eth0 up
ip addr add 192.218.1.1/25 dev eth1 && ip link set eth1 up
echo "nameserver 8.8.8.8" > /etc/resolv.conf

echo 1 > /proc/sys/net/ipv4/ip_forward
route add -net 0.0.0.0 netmask 0.0.0.0 gw 192.218.1.221

# Relay
ping -c 1 8.8.8.8 > /dev/null 2>&1
if [ $? -eq 0 ]; then
    rm -rf /var/lib/apt/lists/*
    apt-get update -o Acquire::Check-Valid-Until=false -o Acquire::Check-Date=false --allow-insecure-repositories --allow-releaseinfo-change
    apt-get install isc-dhcp-relay -y --allow-unauthenticated
    [ -f /usr/sbin/dhcrelay ] && /usr/sbin/dhcrelay -i eth0 -i eth1 192.218.1.202
fi


5. NODE: RIVENDELL

ip addr flush dev eth0; ip addr flush dev eth1
ip addr add 192.218.1.226/30 dev eth0 && ip link set eth0 up
ip addr add 192.218.1.201/29 dev eth1 && ip link set eth1 up
echo "nameserver 8.8.8.8" > /etc/resolv.conf

echo 1 > /proc/sys/net/ipv4/ip_forward
route add -net 0.0.0.0 netmask 0.0.0.0 gw 192.218.1.225

# Relay
ping -c 1 8.8.8.8 > /dev/null 2>&1
if [ $? -eq 0 ]; then
    rm -rf /var/lib/apt/lists/*
    apt-get update -o Acquire::Check-Valid-Until=false -o Acquire::Check-Date=false --allow-insecure-repositories --allow-releaseinfo-change
    apt-get install isc-dhcp-relay -y --allow-unauthenticated
    [ -f /usr/sbin/dhcrelay ] && /usr/sbin/dhcrelay -i eth0 -i eth1 192.218.1.202
fi


6. NODE: MORIA

ip addr add 192.218.1.230/30 dev eth0 && ip link set eth0 up
ip addr add 192.218.1.237/30 dev eth1 && ip link set eth1 up
ip addr add 192.218.1.233/30 dev eth2 && ip link set eth2 up
echo 1 > /proc/sys/net/ipv4/ip_forward
route add -net 0.0.0.0 netmask 0.0.0.0 gw 192.218.1.229
route add -net 192.218.1.128 netmask 255.255.255.192 gw 192.218.1.234
route add -net 192.218.1.192 netmask 255.255.255.248 gw 192.218.1.234


7. NODE: WILDERLAND

ip addr flush dev eth0; ip addr flush dev eth1; ip addr flush dev eth2
ip addr add 192.218.1.234/30 dev eth0 && ip link set eth0 up
ip addr add 192.218.1.129/26 dev eth1 && ip link set eth1 up
ip addr add 192.218.1.193/29 dev eth2 && ip link set eth2 up
echo "nameserver 8.8.8.8" > /etc/resolv.conf

echo 1 > /proc/sys/net/ipv4/ip_forward
route add -net 0.0.0.0 netmask 0.0.0.0 gw 192.218.1.233

# Relay
ping -c 1 8.8.8.8 > /dev/null 2>&1
if [ $? -eq 0 ]; then
    rm -rf /var/lib/apt/lists/*
    apt-get update -o Acquire::Check-Valid-Until=false -o Acquire::Check-Date=false --allow-insecure-repositories --allow-releaseinfo-change
    apt-get install isc-dhcp-relay -y --allow-unauthenticated
    [ -f /usr/sbin/dhcrelay ] && /usr/sbin/dhcrelay -i eth0 -i eth1 -i eth2 192.218.1.202
fi

# Firewall (Redirect & Isolasi)
iptables -t nat -A PREROUTING -s 192.218.1.202 -d 192.218.1.192/29 -j DNAT --to-destination 192.218.1.238
iptables -A FORWARD -s 192.218.1.192/29 -j DROP
iptables -A FORWARD -d 192.218.1.192/29 -j DROP


8. NODE: VILYA (DHCP)

ip addr add 192.218.1.202/29 dev eth0 && ip link set eth0 up
route add -net 0.0.0.0 netmask 0.0.0.0 gw 192.218.1.201
echo "nameserver 8.8.8.8" > /etc/resolv.conf

# Install DHCP (Mode Barbar)
ping -c 1 8.8.8.8 > /dev/null 2>&1
if [ $? -eq 0 ]; then
    rm -rf /var/lib/apt/lists/*
    apt-get update -o Acquire::Check-Valid-Until=false -o Acquire::Check-Date=false --allow-insecure-repositories --allow-releaseinfo-change
    apt-get install isc-dhcp-server -y --allow-unauthenticated
    
    echo 'INTERFACESv4="eth0"' > /etc/default/isc-dhcp-server
    cat > /etc/dhcp/dhcpd.conf <<EOF
default-lease-time 600; max-lease-time 7200; option domain-name-servers 192.218.1.203;
subnet 192.218.1.200 netmask 255.255.255.248 {}
subnet 192.218.0.0 netmask 255.255.255.0 { range 192.218.0.10 192.218.0.200; option routers 192.218.0.1; }
subnet 192.218.1.0 netmask 255.255.255.128 { range 192.218.1.10 192.218.1.100; option routers 192.218.1.1; }
subnet 192.218.1.128 netmask 255.255.255.192 { range 192.218.1.130 192.218.1.180; option routers 192.218.1.129; }
subnet 192.218.1.192 netmask 255.255.255.248 { range 192.218.1.194 192.218.1.198; option routers 192.218.1.193; }
EOF
    service isc-dhcp-server restart
fi

# Firewall No Ping
iptables -A INPUT -p icmp --icmp-type echo-request -j DROP


9. NODE: NARYA (DNS)

ip addr add 192.218.1.203/29 dev eth0 && ip link set eth0 up
route add -net 0.0.0.0 netmask 0.0.0.0 gw 192.218.1.201
echo "nameserver 8.8.8.8" > /etc/resolv.conf

ping -c 1 8.8.8.8 > /dev/null 2>&1
if [ $? -eq 0 ]; then
    rm -rf /var/lib/apt/lists/*
    apt-get update -o Acquire::Check-Valid-Until=false -o Acquire::Check-Date=false --allow-insecure-repositories --allow-releaseinfo-change
    apt-get install bind9 -y --allow-unauthenticated
    [ -f /usr/sbin/named ] && mkdir -p /var/run/named && chown bind:bind /var/run/named && /usr/sbin/named -u bind || service bind9 start
fi

# Access Control
iptables -A INPUT -s 192.218.1.202 -p udp --dport 53 -j ACCEPT
iptables -A INPUT -s 192.218.1.202 -p tcp --dport 53 -j ACCEPT
iptables -A INPUT -p udp --dport 53 -j DROP
iptables -A INPUT -p tcp --dport 53 -j DROP


10. NODE: PALANTIR (WEB)

ip addr add 192.218.1.218/30 dev eth0 && ip link set eth0 up
route add -net 0.0.0.0 netmask 0.0.0.0 gw 192.218.1.217
echo "nameserver 8.8.8.8" > /etc/resolv.conf

ping -c 1 8.8.8.8 > /dev/null 2>&1
if [ $? -eq 0 ]; then
    rm -rf /var/lib/apt/lists/*
    apt-get update -o Acquire::Check-Valid-Until=false -o Acquire::Check-Date=false --allow-insecure-repositories --allow-releaseinfo-change
    apt-get install nginx -y --allow-unauthenticated
    echo "Welcome to Palantir" > /var/www/html/index.html
    service nginx start
fi

# Port Scan & Time
iptables -N PORTSCAN
iptables -A INPUT -m state --state NEW -j PORTSCAN
iptables -A PORTSCAN -m recent --name PSCAN --update --seconds 20 --hitcount 15 -j LOG --log-prefix "PORT_SCAN_DETECTED "
iptables -A PORTSCAN -m recent --name PSCAN --update --seconds 20 --hitcount 15 -j DROP
iptables -A PORTSCAN -m recent --name PSCAN --set -j ACCEPT
iptables -A INPUT -p tcp --dport 80 -s 192.218.1.0/25 -m time --timestart 07:00 --timestop 15:00 -j ACCEPT
iptables -A INPUT -p tcp --dport 80 -s 192.218.0.0/24 -m time --timestart 17:00 --timestop 23:00 -j ACCEPT
iptables -A INPUT -p tcp --dport 80 -j DROP


11. NODE: IRONHILLS (WEB)

ip addr add 192.218.1.238/30 dev eth0 && ip link set eth0 up
route add -net 0.0.0.0 netmask 0.0.0.0 gw 192.218.1.237
echo "nameserver 8.8.8.8" > /etc/resolv.conf

ping -c 1 8.8.8.8 > /dev/null 2>&1
if [ $? -eq 0 ]; then
    rm -rf /var/lib/apt/lists/*
    apt-get update -o Acquire::Check-Valid-Until=false -o Acquire::Check-Date=false --allow-insecure-repositories --allow-releaseinfo-change
    apt-get install nginx -y --allow-unauthenticated
    echo "Welcome to IronHills" > /var/www/html/index.html
    service nginx start
fi

# Limit & Weekend
iptables -A INPUT -p tcp --dport 80 -m connlimit --connlimit-above 3 -j DROP
iptables -A INPUT -p tcp --dport 80 -s 192.218.1.128/26 -m time --weekdays Sat,Sun -j ACCEPT
iptables -A INPUT -p tcp --dport 80 -s 192.218.1.192/29 -m time --weekdays Sat,Sun -j ACCEPT
iptables -A INPUT -p tcp --dport 80 -s 192.218.0.0/24 -m time --weekdays Sat,Sun -j ACCEPT
iptables -A INPUT -p tcp --dport 80 -j DROP


12. CLIENT (Elendil, Isildur, dll)

Jalankan manual di terminal client

# 1. Pancing IP Sementara (Contoh Elendil: 192.218.0.222, Gateway 192.218.0.1)
ip addr add 192.218.0.222/24 dev eth0; ip link set eth0 up; route add default gw 192.218.0.1
echo "nameserver 8.8.8.8" > /etc/resolv.conf

# 2. Install dhclient
rm -rf /var/lib/apt/lists/*
apt-get update -o Acquire::Check-Valid-Until=false -o Acquire::Check-Date=false --allow-insecure-repositories --allow-releaseinfo-change
apt-get install isc-dhcp-client -y --allow-unauthenticated

# 3. Request DHCP
ip addr flush dev eth0; dhclient eth0 -v
