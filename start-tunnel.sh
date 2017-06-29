#! sh

my_private_key=$1

uci delete network.wg0

# add interface
uci set network.wg0='interface'
uci set network.wg0.proto='wireguard'
uci set network.wg0.private_key="$my_private_key"

uci add_list firewall.@zone[1].network='wg0'

uci commit
