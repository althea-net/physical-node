#!sh

exit_public_key=$1
exit_endpoint_ip=$2

my_lan_ip=$3
my_lan_netmask=$4
my_lan_cidr=$5

uci delete network.@wireguard_wg0[0]

# add peer
uci add network wireguard_wg0
uci set network.@wireguard_wg0[0].public_key="$exit_public_key"
uci set network.@wireguard_wg0[0].allowed_ips='0.0.0.0/0'
uci set network.@wireguard_wg0[0].endpoint_host="$exit_endpoint_ip"
uci set network.@wireguard_wg0[0].persistent_keepalive='25'
uci set network.@wireguard_wg0[0].route_allowed_ips='1'

uci add_list network.wg0.addresses="$my_lan_cidr"

uci set network.lan.ipaddr="$my_lan_ip"
uci set network.lan.netmask="$my_lan_netmask"

uci commit
