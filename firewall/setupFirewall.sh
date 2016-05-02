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

# Allowed internal ports
INTPRT="1024:65535"

# The internal interface designation
INTIF="eth0"

# Internal interface IP address
INTIP=`hostname -I`

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

echo "Creating rules for TCP ports..."
TCP_PORTS="443"
for PORT in $TCP_PORTS
do
  echo "  Allowing TCP INPUT/OUTPUT for port ${PORT}..."
  iptables -A INPUT -i $INTIF -p tcp -s $UNIVERSE --sport $PORT -d $INTIP --dport $INTPRT -j ACCEPT
  #iptables -A INPUT -i $INTIF -p tcp -s $UNIVERSE --sport $PORT -d $INTIP --dport $INTPRT -m state --state NEW,ESTABLISHED -j ACCEPT
  iptables -A OUTPUT -o $INTIF -p tcp -s $INTIP --sport $INTPRT -d $UNIVERSE --dport $PORT -j ACCEPT
  #iptables -A OUTPUT -o $INTIF -p tcp -s $INTIP --sport $INTPRT -d $UNIVERSE --dport $PORT -m state --state ESTABLISHED -j ACCEPT
done

echo "Creating rules for UDP ports..."
UDP_PORTS="53"
for PORT in $UDP_PORTS
do
  echo "  Allowing UDP INPUT/OUTPUT for port ${PORT}..."
  iptables -A INPUT -i $INTIF -p udp -s $UNIVERSE --sport $PORT -d $INTIP --dport $INTPRT -j ACCEPT
  #iptables -A INPUT -i $INTIF -p udp -s $UNIVERSE --sport $PORT -d $INTIP --dport $INTPRT -m state --state NEW,ESTABLISHED -j ACCEPT
  iptables -A OUTPUT -o $INTIF -p udp -s $INTIP --sport $INTPRT -d $UNIVERSE --dport $PORT -j ACCEPT
  #iptables -A OUTPUT -o $INTIF -p udp -s $INTIP --sport $INTPRT -d $UNIVERSE --dport $PORT -m state --state ESTABLISHED -j ACCEPT
done

echo "Blocking all other ports..."
iptables -A INPUT -i $INTIF -s $UNIVERSE -d $UNIVERSE -j drop-and-log
iptables -A OUTPUT -o $INTIF -s $UNIVERSE -d $UNIVERSE -j drop-and-log
iptables -A FORWARD -i $INTIF -j drop-and-log

echo "Done!"
