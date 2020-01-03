# Summary

- Create virtual private network
- Use OpenVPN with TUN and server/client model
- Create server/client certificates using OpenSSL

# Network diagram

- OpenVPN runs on A1 and B1 and connect them with vpn
- A1 is the default gateway on net2
- B1 is the default gateway on net3
- A2 can talk to B2 with openvpn, and vice versa

<pre>
         192.168.1.0/24 (net1)
          --+-----------+--
            |10.1.0.0/24|
        .101| (openvpn) |.102
            | -+-----+- |
            |.1|   .2|  |
 +------+ +-+--+-+ +-+--+-+ +------+
 |  A2  | |  A1  | |  B1  | |  B2  |
 +--+---+ +--+---+ +--+---+ +--+---+
.102|    .101|    .101|    .102|
  --+--------+--    --+--------+--
  192.168.2.0/24    192.168.3.0/24
      (net2)            (net3)
</pre>

# Test

- Host environment
  - macOS Catalina 10.15.2
  - VirtualBox 6.0.14
  - Vagrant 2.2.6
- Guest environment
  - Ubuntu 16.04.6 LTS (ubuntu/xenial64 20191217.0.0)
  - OpenVPN 2.3.10
  - OpenSSL 1.0.2g  1 Mar 2016 

```
daisuke@daisukenoMac-mini openvpn-server-client % vagrant ssh a2
vagrant@a2:~$ 
vagrant@a2:~$ ping b2
PING b2 (192.168.3.102) 56(84) bytes of data.
From 10.0.2.2 icmp_seq=6 Destination Net Unreachable
From 10.0.2.2 icmp_seq=7 Destination Net Unreachable
From 10.0.2.2 icmp_seq=8 Destination Net Unreachable
From 10.0.2.2 icmp_seq=9 Destination Net Unreachable
From 10.0.2.2 icmp_seq=10 Destination Net Unreachable
From 10.0.2.2 icmp_seq=11 Destination Net Unreachable
From 10.0.2.2 icmp_seq=12 Destination Net Unreachable
From 10.0.2.2 icmp_seq=13 Destination Net Unreachable
From 10.0.2.2 icmp_seq=14 Destination Net Unreachable
From 10.0.2.2 icmp_seq=15 Destination Net Unreachable
From 10.0.2.2 icmp_seq=16 Destination Net Unreachable
From 10.0.2.2 icmp_seq=17 Destination Net Unreachable
^C
--- b2 ping statistics ---
17 packets transmitted, 0 received, +12 errors, 100% packet loss, time 16041ms

vagrant@a2:~$ ping b2
PING b2 (192.168.3.102) 56(84) bytes of data.
From 10.0.2.2 icmp_seq=1 Destination Net Unreachable
From 10.0.2.2 icmp_seq=2 Destination Net Unreachable
From 10.0.2.2 icmp_seq=3 Destination Net Unreachable
From 10.0.2.2 icmp_seq=4 Destination Net Unreachable
^C
--- b2 ping statistics ---
4 packets transmitted, 0 received, +4 errors, 100% packet loss, time 2997ms

vagrant@a2:~$ exit
logout
Connection to 127.0.0.1 closed.
daisuke@daisukenoMac-mini openvpn-server-client % vagrant ssh a1
vagrant@a1:~$ ping b2
PING b2 (192.168.3.102) 56(84) bytes of data.
64 bytes from b2 (192.168.3.102): icmp_seq=1 ttl=63 time=0.869 ms
64 bytes from b2 (192.168.3.102): icmp_seq=3 ttl=63 time=1.14 ms
64 bytes from b2 (192.168.3.102): icmp_seq=6 ttl=63 time=1.12 ms
64 bytes from b2 (192.168.3.102): icmp_seq=7 ttl=63 time=1.13 ms
64 bytes from b2 (192.168.3.102): icmp_seq=8 ttl=63 time=1.13 ms
64 bytes from b2 (192.168.3.102): icmp_seq=9 ttl=63 time=0.943 ms
^C
--- b2 ping statistics ---
9 packets transmitted, 6 received, 33% packet loss, time 8025ms
rtt min/avg/max/mdev = 0.869/1.057/1.145/0.112 ms
vagrant@a1:~$ 
vagrant@a1:~$ ping b2
PING b2 (192.168.3.102) 56(84) bytes of data.
64 bytes from b2 (192.168.3.102): icmp_seq=1 ttl=63 time=0.581 ms
64 bytes from b2 (192.168.3.102): icmp_seq=2 ttl=63 time=1.18 ms
^C
--- b2 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 999ms
rtt min/avg/max/mdev = 0.581/0.881/1.182/0.301 ms
vagrant@a1:~$ exit
logout
Connection to 127.0.0.1 closed.
daisuke@daisukenoMac-mini openvpn-server-client % vagrant ssh a2
Last login: Thu Jan  2 09:21:33 2020 from 10.0.2.2
vagrant@a2:~$ 
vagrant@a2:~$ ping b2
PING b2 (192.168.3.102) 56(84) bytes of data.
From 10.0.2.2 icmp_seq=6 Destination Net Unreachable
From 10.0.2.2 icmp_seq=7 Destination Net Unreachable
From 10.0.2.2 icmp_seq=8 Destination Net Unreachable
^C
--- b2 ping statistics ---
8 packets transmitted, 0 received, +3 errors, 100% packet loss, time 7004ms

vagrant@a2:~$ 
vagrant@a2:~$ exit
logout
Connection to 127.0.0.1 closed.
daisuke@daisukenoMac-mini openvpn-server-client % 
daisuke@daisukenoMac-mini openvpn-server-client % vagrant ssh b2
vagrant@b2:~$ 
vagrant@b2:~$ ping a2
PING a2 (192.168.2.102) 56(84) bytes of data.
64 bytes from a2 (192.168.2.102): icmp_seq=2 ttl=62 time=1.75 ms
64 bytes from a2 (192.168.2.102): icmp_seq=6 ttl=62 time=1.66 ms
64 bytes from a2 (192.168.2.102): icmp_seq=8 ttl=62 time=1.58 ms
64 bytes from a2 (192.168.2.102): icmp_seq=9 ttl=62 time=1.52 ms
64 bytes from a2 (192.168.2.102): icmp_seq=10 ttl=62 time=1.37 ms
64 bytes from a2 (192.168.2.102): icmp_seq=11 ttl=62 time=1.55 ms
64 bytes from a2 (192.168.2.102): icmp_seq=12 ttl=62 time=1.23 ms
^C
--- a2 ping statistics ---
12 packets transmitted, 7 received, 41% packet loss, time 11032ms
rtt min/avg/max/mdev = 1.234/1.525/1.751/0.166 ms
vagrant@b2:~$ 
vagrant@b2:~$ exit
logout
Connection to 127.0.0.1 closed.
daisuke@daisukenoMac-mini openvpn-server-client % 
daisuke@daisukenoMac-mini openvpn-server-client % vagrant ssh a2
Last login: Thu Jan  2 09:22:30 2020 from 10.0.2.2
vagrant@a2:~$ 
vagrant@a2:~$ ping b2
PING b2 (192.168.3.102) 56(84) bytes of data.
64 bytes from b2 (192.168.3.102): icmp_seq=1 ttl=62 time=0.858 ms
64 bytes from b2 (192.168.3.102): icmp_seq=2 ttl=62 time=1.52 ms
64 bytes from b2 (192.168.3.102): icmp_seq=3 ttl=62 time=1.50 ms
64 bytes from b2 (192.168.3.102): icmp_seq=4 ttl=62 time=1.17 ms
64 bytes from b2 (192.168.3.102): icmp_seq=5 ttl=62 time=1.50 ms
64 bytes from b2 (192.168.3.102): icmp_seq=8 ttl=62 time=1.44 ms
64 bytes from b2 (192.168.3.102): icmp_seq=10 ttl=62 time=1.23 ms
64 bytes from b2 (192.168.3.102): icmp_seq=12 ttl=62 time=1.21 ms
64 bytes from b2 (192.168.3.102): icmp_seq=13 ttl=62 time=1.54 ms
^C
--- b2 ping statistics ---
13 packets transmitted, 9 received, 30% packet loss, time 12193ms
rtt min/avg/max/mdev = 0.858/1.333/1.540/0.218 ms
vagrant@a2:~$ 
```

# Issues/Notes

- Currently this VPN is unreliable. Ping packets are partially lost or completely unreachable in some cases.
- After doing "vagrant reload --provision", unnecessary lines are appended to /etc/hosts ~~and /etc/sysctl.conf~~.
- During provisioning, lot of messages are outputted by openssl and few are useful.

# References

- openvpn(8)
- OPENSSL(1SSL)
- CA(1SSL)
- REQ(1SSL)
- https://www.openvpn.jp/document/how-to/
- https://www.vagrantup.com/docs/networking/public_network.html#default-router

