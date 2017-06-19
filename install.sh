#!sh
# This shell script can be run to set up an Althea physical node on a freshly flashed LEDE 17.01 instance.
# It was built for MyNet N600 routers, but may work on other routers as well.
# This will probably be supplemented or replaced with custom a daemon soon.

opkg update
opkg install wireguard

