# Summary

- Create virtual private network
- Use OpenVPN with TUN and server/client model
- Create server/client certificates using OpenSSL

# Network diagram

- OpenVPN runs on A1 and B1 and connect them with vpn
- A1 is the gateway to net3 from net2
- B1 is the gateway to net2 from net3
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
  - VirtualBox 6.0.15
  - Vagrant 2.2.6
- Guest environment
  - VirtualBox instance (memory 256MB)
  - Ubuntu 16.04.6 LTS (ubuntu/xenial64 20200115.0.0)
  - OpenVPN 2.3.10
  - OpenSSL 1.0.2g  1 Mar 2016 


## A2 can ping to B2, and vice versa

```
daisuke@daisukenoMac-mini openvpn-client-server % vagrant ssh a2 --command "ping -qc10 b2"
PING b2 (192.168.3.102) 56(84) bytes of data.

--- b2 ping statistics ---
10 packets transmitted, 10 received, 0% packet loss, time 9014ms
rtt min/avg/max/mdev = 1.177/1.466/1.639/0.137 ms
Connection to 127.0.0.1 closed.
daisuke@daisukenoMac-mini openvpn-client-server % vagrant ssh b2 --command "ping -qc10 a2"
PING a2 (192.168.2.102) 56(84) bytes of data.

--- a2 ping statistics ---
10 packets transmitted, 10 received, 0% packet loss, time 9179ms
rtt min/avg/max/mdev = 0.771/1.157/1.611/0.246 ms
Connection to 127.0.0.1 closed.
daisuke@daisukenoMac-mini openvpn-client-server % 
```

## Network packets are transported through openvpn

```
vagrant@b1:~$ sudo tcpdump --interface=enp0s8
tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
listening on enp0s8, link-type EN10MB (Ethernet), capture size 262144 bytes
02:43:46.406408 IP 192.168.1.101.openvpn > 192.168.1.102.openvpn: UDP, length 125
02:43:46.406983 IP 192.168.1.102.openvpn > 192.168.1.101.openvpn: UDP, length 125
02:43:47.409070 IP 192.168.1.101.openvpn > 192.168.1.102.openvpn: UDP, length 125
02:43:47.409683 IP 192.168.1.102.openvpn > 192.168.1.101.openvpn: UDP, length 125
02:43:48.410256 IP 192.168.1.101.openvpn > 192.168.1.102.openvpn: UDP, length 125
02:43:48.410914 IP 192.168.1.102.openvpn > 192.168.1.101.openvpn: UDP, length 125
02:43:49.412123 IP 192.168.1.101.openvpn > 192.168.1.102.openvpn: UDP, length 125
02:43:49.412728 IP 192.168.1.102.openvpn > 192.168.1.101.openvpn: UDP, length 125
02:43:50.413965 IP 192.168.1.101.openvpn > 192.168.1.102.openvpn: UDP, length 125
02:43:50.414680 IP 192.168.1.102.openvpn > 192.168.1.101.openvpn: UDP, length 125
02:43:51.415775 IP 192.168.1.101.openvpn > 192.168.1.102.openvpn: UDP, length 125
02:43:51.416270 IP 192.168.1.102.openvpn > 192.168.1.101.openvpn: UDP, length 125
02:43:52.416419 IP 192.168.1.101.openvpn > 192.168.1.102.openvpn: UDP, length 125
02:43:52.416958 IP 192.168.1.102.openvpn > 192.168.1.101.openvpn: UDP, length 125
02:43:52.421888 ARP, Request who-has 192.168.1.102 tell 192.168.1.101, length 46
02:43:52.421906 ARP, Reply 192.168.1.102 is-at 08:00:27:2c:39:fe (oui Unknown), length 28
02:43:53.418290 IP 192.168.1.101.openvpn > 192.168.1.102.openvpn: UDP, length 125
02:43:53.418910 IP 192.168.1.102.openvpn > 192.168.1.101.openvpn: UDP, length 125
02:43:54.420301 IP 192.168.1.101.openvpn > 192.168.1.102.openvpn: UDP, length 125
02:43:54.420825 IP 192.168.1.102.openvpn > 192.168.1.101.openvpn: UDP, length 125
02:43:55.421461 IP 192.168.1.101.openvpn > 192.168.1.102.openvpn: UDP, length 125
02:43:55.422079 IP 192.168.1.102.openvpn > 192.168.1.101.openvpn: UDP, length 125
02:43:58.422166 ARP, Request who-has 192.168.1.101 tell 192.168.1.102, length 28
02:43:58.422524 ARP, Reply 192.168.1.101 is-at 08:00:27:7d:c1:58 (oui Unknown), length 46
^C
24 packets captured
24 packets received by filter
0 packets dropped by kernel
vagrant@b1:~$ 
```

# Issues/Notes

- ~~Currently this VPN is unreliable. Ping packets are partially lost or completely unreachable in some cases.~~
- After doing "vagrant reload --provision", unnecessary lines are appended to /etc/hosts ~~and /etc/sysctl.conf~~.
- During provisioning, lot of messages are outputted by openssl and few are useful.

# References

- openvpn(8)
- OPENSSL(1SSL)
- CA(1SSL)
- REQ(1SSL)
- https://www.openvpn.jp/document/how-to/
- https://www.vagrantup.com/docs/networking/public_network.html#default-router

