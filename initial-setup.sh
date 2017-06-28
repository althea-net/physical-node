#! sh

sh install.sh
sh generate-keys.sh
sh start-tunnel.sh "$(cat privatekey)"