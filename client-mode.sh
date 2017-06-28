#!sh

ssid=$1
encryption=$2
key=$3

uci del wireless.@wifi-device[0].disabled
uci del wireless.@wifi-iface[0].network
uci set wireless.@wifi-iface[0].mode='sta'

uci commit wireless
wifi

uci del network.wan.ifname
uci set network.wan.proto='dhcp'
uci commit network

uci set wireless.@wifi-iface[0].network='wan'
uci set wireless.@wifi-iface[0].mode='sta'
uci set wireless.@wifi-iface[0].ssid="$ssid"
uci set wireless.@wifi-iface[0].encryption="$encryption"
uci set wireless.@wifi-iface[0].key="$key"

uci commit wireless
ifup wan
wifi
