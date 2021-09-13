# loopback is unlimited
#
# Allowed inbound:
# * 53   DNS
# * 80   HTTP
# * 443  HTTPS
# * 222  SSH remapped from default
# * All other port connection attempts are logged and dropped.
#
# Allowed outbound:
# * 53   DNS
# * 443  HTTPS
#
# Configures the following redirects to avoid having containers running as root
# * 53 -> 3053
# * 80 -> 8080
#
# Based off of www.aboutdebian.com/firewall.htm

set -e
set -x

# Any address/port
UNIVERSE="0.0.0.0/0"

# The internal interface designation
INTERFACE="eno1"

echo "Creating backup..."
DATE=`date +%Y%m%d-%H%M%S`
BACKUP=${DATE}-iptables.bak
NATBACKUP=${DATE}-nat-iptables.bak
iptables -L -v > $BACKUP
iptables -L -v -t nat > $NATBACKUP
echo "Created backups $BACKUP $NATBACKUP"

echo "Flushing iptables"
iptables -F
iptables -X
iptables -Z
iptables -F -t nat
iptables -X -t nat
iptables -Z -t nat
echo "Flushing iptables - Done"

# Comment out and replace drop-and-log with DROP if you don't want to log
# packets being dropped.
# Logs can be viewed with 'dmesg'
echo "Creating drop-and-log rule"
iptables -N drop-and-log
iptables -A drop-and-log -j LOG --log-level info
iptables -A drop-and-log -j DROP
echo "Creating drop-and-log rule - Done"

echo "Allowing unlimited traffic on loopback"
iptables -A INPUT -i lo -j ACCEPT
#iptables -A OUPTUT -o lo -j ACCEPT
echo "Allowing unlimited traffic on loopback - Done"

echo "Creating rules for ports as client..."
TCP_PORTS=(53 443)
for PORT in $TCP_PORTS; do
    echo "  Allowing OUTPUT as client for port ${PORT}..."
    iptables -A OUTPUT -o $INTERFACE -p tcp -d $UNIVERSE --dport $PORT -j ACCEPT
    iptables -A OUTPUT -o $INTERFACE -p udp -d $UNIVERSE --dport $PORT -j ACCEPT
done

echo "Creating rules for ports as host..."
TCP_PORTS=(53 80 222)
for PORT in $TCP_PORTS; do
    echo "  Allowing INPUT for port ${PORT}..."
    iptables -A INPUT -i $INTERFACE -p tcp --dport $PORT -j ACCEPT
    iptables -A INPUT -i $INTERFACE -p udp --dport $PORT -j ACCEPT
done

echo "Creating rules for redirecting ports..."
REDIRECT_PORTS=("53:3053" "80:8080")
for PORT in "${REDIRECT_PORTS[@]}"; do
	FROM=`echo "$PORT" | cut -d ":" -f 1`
	TO=`echo "$PORT" | cut -d ":" -f 2`
    echo "  Redirecting ${FROM} => ${TO}..."
	iptables -A INPUT -i $INTERFACE -p tcp --dport $FROM -j ACCEPT
	iptables -A INPUT -i $INTERFACE -p udp --dport $FROM -j ACCEPT
	iptables -A INPUT -i $INTERFACE -p tcp --dport $TO -j ACCEPT
	iptables -A INPUT -i $INTERFACE -p udp --dport $TO -j ACCEPT
	iptables -A PREROUTING -t nat -i $INTERFACE -p tcp --dport $FROM -m state --state NEW -j REDIRECT --to-port $TO
	iptables -A PREROUTING -t nat -i $INTERFACE -p udp --dport $FROM -m state --state NEW -j REDIRECT --to-port $TO
done

#echo "Blocking all other ports..."
#iptables -A INPUT -i $INTERFACE -s $UNIVERSE -d $UNIVERSE -j drop-and-log
#iptables -A OUTPUT -o $INTERFACE -s $UNIVERSE -d $UNIVERSE -j drop-and-log
#iptables -A FORWARD -i $INTERFACE -j drop-and-log

echo "Done!"
