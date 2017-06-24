#! sh

my_tunnel_ip=$1

sh install.sh
sh generate-keys.sh
sh start-tunnel.sh "$(cat privatekey)" "$my_tunnel_ip"

/etc/init.d/network reload