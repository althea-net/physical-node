#!sh

uci set wireless.radio1.disabled=0

uci commit wireless
ifup wan
wifi

