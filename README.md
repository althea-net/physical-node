# physical-node

This is a set of scripts to let you set up an Althea physical node on a fresh LEDE (OpenWRT) 17.01 instance. It creates the necessary network configuration and installs various tunneling, payment, and routing daemons.

It goes along with [exit-node](https://github.com/althea-mesh/exit-node) which does similar configuration for Ubuntu.

# Installing

1. Plug an ethernet cable into one of the 4 numbered ports in the back of your WD MyNet N600. Plug the other end into your computer.

1. Give 192.168.1.10/24 to the ethernet interface attached to the N600.
    `ip addr add 192.168.1.10/24 dev <your interface>`

1. Turn the router off, and hold down the reset switch (accesible through a pin hole on the underside of the router). Turn the router back on and wait about 15 seconds until the power LED on the front starts flashing slowly.

1. Browse to http://192.168.1.1. There should be a dialog allowing you to select a firmware image to upload to the router. For some reason, this can be really fickle. Try to bringing the interface down and back up again, re-adding 192.168.1.10/24, etc. until the upload dialog shows up.

1. Download the latest snapshot of [LEDE for the N600](https://downloads.lede-project.org/snapshots/targets/ar71xx/generic/lede-ar71xx-generic-mynet-n600-squashfs-factory.bin), and upload it to the router.

1. The router will now flash itself with the firmware. One easy way to check when it is finished is to run `ping 192.168.1.1` and wait until the pings are consistently getting through.

1. Copy the contents of this folder to the home directory of the router.
    `scp -r ./* root@192.168.1.1:~/`

1. If you have a wired connection to the internet, plug this into the port on the back of the router labeled "Internet". Try `ping 8.8.8.8` to see if your connection is working. If you do not have a wired connection, you will need to put the router into client mode on one of its radios. This will allow it to use a nearby wi-fi hotspot to connect to the internet. To do this, run `sh client-mode.sh <ssid of the network> <type of encryption (usually 'psk' or 'psk2'> <wifi password>`

1. Run `sh initial-setup.sh`.

1. You'll have to reboot the router for the configuration to take effect. This shouldn't be necessary, but it is. If things have gone well, you should be able to run 
    `wg` and get something like
    ```
    interface: wg0
      public key: 7TNSB84j9afBmKhzknXk+beuY2UMrNETwkUffmFx/wg=
      private key: (hidden)
      listening port: 54147
    ```

    and run `ip addr show wg0` and get something like
    ```
    8: wg0: <POINTOPOINT,NOARP,UP,LOWER_UP> mtu 1420 qdisc noqueue state UNKNOWN qlen 1
        link/[65534]
    ```

1. Set up the [exit-node](https://github.com/althea-mesh/exit-node) if you haven't already and come back when that's done.

1. Add the exit node to your router's configuration by running `sh add-exit-node.sh <exit node publickey> <exit node endpoint IP> <your IP> <your netmask> <your CIDR>`. The exit node public key can be found in the home directory of the exit node you just set up. The exit node endpoint IP is simply the public IP of the server your exit node is running on. Your IP is the IP that identifies you to the exit node. If you don't know what to use here, use 192.168.23.1. Your netmask is the size of the subnet your physical node will give out to clients. If you don't know what to use here, use 255.255.255.0. Your CIDR is the previous two values in CIDR notation. If you don't know what to use here, use 192.168.23.1/24.

1. Reboot the router again. If all has gone well, you should be able to run `wg` and get something like:
    ```
    interface: wg0
        public key: yR74L62IiS1yhtO3T8m1gEo0I3FeB2KoYIE2xWN62Ug=
        private key: (hidden)
        listening port: 34081

    peer: M27zzpg7VgjG9ulNojE2IjmZFrDYl4wnvChFykqd23Y=
        endpoint: 107.170.234.148:51820
        allowed ips: 0.0.0.0/0
        latest handshake: 5 seconds ago
        transfer: 3.64 KiB received, 8.17 KiB sent
        persistent keepalive: every 25 seconds
    ```
    "latest handshake" indicates the last time your router was able to make contact with the exit node's tunnel. You should also be able to ping destinations on the internet. You should also be able to connect to the "LEDE" wifi network on a laptop and phone and use the internet.

Read the [whitepaper](http://altheamesh.com/documents/whitepaper.pdf) to see what Althea is all about.

## Progress
We are developing Althea incrementally over several stages:

- [x] **Exit node to user node tunnel: (under development)** The exit node is basically a VPN server, and the physical node uses the VPN for internet access. Users of physical nodes can select an exit node to use and access the internet over a secure tunnel without having to mess with VPN clients on their personal devices. This does not have much to do with incentivized mesh yet, but it forms a base of security and privacy. It can also be useful for people who don't want ISPs selling their browsing history and don't mind setting up a VPN server themselves.

- [] **Metering and payments:** The physical node and the exit node both keep track of how much traffic has been sent over the tunnel, and the physical node automatically pays for the traffic. This lets us start to build infrastructure around metering traffic, paying for it, and cutting off service in the case of non-payment. It can also be useful for people who want to set up VPN servers and charge others for the service.

- [] **Unverified mesh:** Several physical nodes can form a mesh network, which routes traffic to one or more exit nodes, over the best and cheapest paths. Physical nodes meter traffic forwarded for their neighbors, and charge each other for it. This remains vulnerable to low-level attacks on the routing protocol, but will allow us to test the network in a controlled real-world environment, giving users internet access, and receiving payment.

- [] **Verified mesh:** Physical nodes constantly test the routing metrics advertised by their neighbors, allowing them to verify the quality of the routes, and building a "local reputation" database about their neighbors. This starts to open the network up to secure participation by a wider range of operators, allowing it to grow quickly. Physical nodes still can't be that mobile though, because they need to open channels and verify the routes of other nodes they are paying to forward.

- [] **Future evolution...:** The "Verified mesh" stage proves out the basic concept. But there's still a lot of work beyond that, some of which is not yet covered even in the white paper:
  - Rigorous security testing.
  - Multihop channels: Using hashlock techniques, nodes could transfer payments to their neighbors over a network of multihop channels, allowing them to move to a new physical location without waiting for a channel to open to pay for a connection to their new neighbors.
  - Transitive reputation: Nodes could also get information on the accuracy of new neighbors from other nodes that they trust on some level. This will also enable mobility.
  - On-device user node: Build a stripped down "physical node" app for laptops and mobile devices. This will allow users to pay for traffic and roam without carrying a physical OpenWRT node with them.

## How to help
Building this system out requires a large range of skills:

- Linux networking: Obviously a big part of the system.
- Cryptocurrency: We'll be using pretty basic payment channels to start out, so it's not like we need a huge amount of consensus and blockchain wonkery at first. However, the choices we make early on will have big effects, since the space is changing raidly. Multihop channels and transitive reputation will require a bit more expertise later on.
- Frontend design and development: The concept of paying per kilobyte on a cryptocurrency mesh network will be unfamiliar to most people. We'll need intuitive UX/UI design and solid cross-platform frontend code.

If you want to help, or just say hi, introduce yourself in our [Matrix chat](https://riot.im/app/#/room/#althea:matrix.org)