#!/bin/bash
if [[ "$1" != "" ]]; then
     WSHOSTNAME="$1"
     echo "Windows hostname supplied is: " $WSHOSTNAME

     echo "Setting Default inbound policy to Accept"
     iptables -P INPUT ACCEPT

     echo "Flushing all existing policy"
     iptables -F

     echo "Setting inbound policy to accept all connections from localhost"
     iptables -A INPUT -i lo -j ACCEPT

     echo "Setting inbound policy to accept all ongoing connections"
     iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

     echo "Setting inbound policy to accept SSH connections"
     iptables -A INPUT -p tcp --dport 22 -j ACCEPT

     echo "Setting inbound policy to accept inbound connection from " $WSHOSTNAME
     iptables -A INPUT -s $WSHOSTNAME -j ACCEPT

     echo "Setting Default inbound policy to Reject everything"
     iptables -P INPUT DROP

     echo "Setting Default forward policy to Reject everything"
     iptables -P FORWARD DROP

     echo "Setting Default outbound policy to Allow everything"
     iptables -P OUTPUT ACCEPT

     echo "Saving the Firewall rules"
     service iptables save

     echo "Firewall configurations completed"

else
     echo "Windows hostname not supplied.. firewall not configured"
fi
