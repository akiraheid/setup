#!/bin/bash

# A script to configure the system to allow only:
# - loopback
# - 53 (DNS)
# - 443 (HTTPS)
#
# All other port connection attempts are logged and dropped.
#
# Add other ports as desired.
#
# Based off of www.aboutdebian.com/firewall.htm

# Any address/port
UNIVERSE="0.0.0.0/0"

# Allowed "any" ports
ANYPORTS="1024:65535"

# The internal interface designation
INTERFACE="eth0"

# Internal interface IP address
MYIP=`hostname -I`

echo "Storing backup..."
iptables -L -v > iptables.bak

echo "Flushing iptables..."
iptables -F
iptables -X

# Comment out and replace drop-and-log with DROP if you don't want to log
# packets being dropped.
# Logs can be viewed with 'dmesg'
echo "Creating drop-and-log rule..."
iptables -N drop-and-log
iptables -A drop-and-log -j LOG --log-level info
iptables -A drop-and-log -j DROP

echo "Setting defaults to drop all for INPUT/OUTPUT/FORWARD..."
iptables -P INPUT drop-and-log
iptables -P OUTPUT drop-and-log
iptables -P FORWARD drop-and-log

echo "Allowing unlimited traffic on loopback..."
iptables -A INPUT -i lo -s $UNIVERSE -d $UNIVERSE -j ACCEPT
iptables -A OUPTUT -o lo -s $UNIVERSE -d $UNIVERSE -j ACCEPT

# Ports to have open if client
echo "Creating rules for TCP ports as client..."
TCP_PORTS="443"
for PORT in $TCP_PORTS
do
  echo "  Allowing TCP INPUT/OUTPUT as client for port ${PORT}..."
  iptables -A INPUT -i $INTERFACE -p tcp -s $UNIVERSE --sport $PORT -d $MYIP --dport $ANYPORTS -j ACCEPT
  iptables -A OUTPUT -o $INTERFACE -p tcp -s $MYIP --sport $ANYPORTS -d $UNIVERSE --dport $PORT -j ACCEPT
done

# Ports to have open if hosting
# This is where you would open 22 to act as an SSH server
echo "Creating rules for TCP ports as host for port ${PORT}..."
TCP_PORTS=""
for PORT in $TCP_PORTS
do
  echo "  Allowing TCP INPUT/OUTPUT as host for port ${PORT}..."
  iptables -A INPUT -i $INTERFACE -p tcp -s $UNIVERSE --sport $ANYPORTS -d $MYIP --dport $PORT -j ACCEPT
  iptables -A OUTPUT -o $INTERFACE -p tcp -s $MYIP --sport $PORT -d $UNIVERSE --dport $ANYPORTS -j ACCEPT
done

echo "Creating rules for UDP ports..."
UDP_PORTS="53"
for PORT in $UDP_PORTS
do
  echo "  Allowing UDP INPUT/OUTPUT as client for port ${PORT}..."
  iptables -A INPUT -i $INTERFACE -p udp -s $UNIVERSE --sport $PORT -d $MYIP --dport $ANYPORTS -j ACCEPT
  iptables -A OUTPUT -o $INTERFACE -p udp -s $MYIP --sport $ANYPORTS -d $UNIVERSE --dport $PORT -j ACCEPT
done

echo "Creating rules for UDP ports..."
# This is where you would open a port to act as a UDP server
UDP_PORTS=""
for PORT in $UDP_PORTS
do
  echo "  Allowing UDP INPUT/OUTPUT as host for port ${PORT}..."
  iptables -A INPUT -i $INTERFACE -p udp -s $UNIVERSE --sport $ANYPORTS -d $MYIP --dport $PORT -j ACCEPT
  iptables -A OUTPUT -o $INTERFACE -p udp -s $MYIP --sport $PORT -d $UNIVERSE --dport $ANYPORTS -j ACCEPT
done

echo "Blocking all other ports..."
iptables -A INPUT -i $INTERFACE -s $UNIVERSE -d $UNIVERSE -j drop-and-log
iptables -A OUTPUT -o $INTERFACE -s $UNIVERSE -d $UNIVERSE -j drop-and-log
iptables -A FORWARD -i $INTERFACE -j drop-and-log

echo "Done!"
