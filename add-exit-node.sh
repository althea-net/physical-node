#!sh

my_private_key=$1
my_ip=$2

exit_public_key=$3
exit_ip=$4

# add interface
uci delete network.wg0

uci set network.wg0='interface'
uci set network.wg0.proto='wireguard'
uci set network.wg0.private_key="$my_private_key"
uci add_list network.wg0.ip_addr="$my_ip"

# add peer
uci delete network.wireguard_wg0
uci add network wireguard_wg0

uci set network.@wireguard_wg0[0].public_key="$exit_public_key"
uci set network.@wireguard_wg0[0].allowed_ips='0.0.0.0/0'
uci set network.@wireguard_wg0[0].endpoint_host="$exit_ip"
uci set network.@wireguard_wg0[0].persistent_keepalive='25'
uci set network.@wireguard_wg0[0].route_allowed_ips='1'


uci commit