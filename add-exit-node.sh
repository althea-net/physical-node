#!sh

exit_public_key=$1
exit_endpoint_ip=$2

uci delete network.@wireguard_wg0[0]

# add peer
uci add network wireguard_wg0
uci set network.@wireguard_wg0[0].public_key="$exit_public_key"
uci set network.@wireguard_wg0[0].allowed_ips='0.0.0.0/0'
uci set network.@wireguard_wg0[0].endpoint_host="$exit_endpoint_ip"
uci set network.@wireguard_wg0[0].persistent_keepalive='25'
uci set network.@wireguard_wg0[0].route_allowed_ips='1'


uci commit

# config interface 'wg0'
# 	option proto 'wireguard'
# 	option private_key 'QDI6JzTCu0VbXDVMiz4I3/s2pexwEZtFRLPdqqRERkU='
# 	list addresses '10.0.1.1/24'

# config wireguard_wg0
# 	option public_key 'ORp1m4hkGEivVP2I/mPOVNjw5waSiHOQsE7ztcib808='
# 	list allowed_ips '0.0.0.0/0'
# 	option route_allowed_ips '1'
# 	option endpoint_host '107.170.234.148'
# 	option persistent_keepalive '23'