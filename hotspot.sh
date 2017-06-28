#!sh

uci set wireless.radio1.disabled=0

uci commit wireless
ifup wan
wifi

# config dhcp 'lan'
# 	option interface 'lan'
# 	option start '100'
# 	option limit '150'
# 	option leasetime '12h'
# 	option dhcpv6 'server'
# 	option ra 'server'
