# Summary

- Creating virtual network over existing physical network
- Using OpenVPN with TUN and shared security key

# Network diagram

- OpenVPN runs on A1 and B1 and makes vpn over net1
- A1 (B1) is the default gateway on net2 (net3)
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

```
daisuke@daisukenoMac-mini OpenVPN % vagrant ssh b2
vagrant@b2:~$ ping -c1 192.168.2.102
PING 192.168.2.102 (192.168.2.102) 56(84) bytes of data.
64 bytes from 192.168.2.102: icmp_seq=1 ttl=62 time=0.794 ms

--- 192.168.2.102 ping statistics ---
1 packets transmitted, 1 received, 0% packet loss, time 0ms
rtt min/avg/max/mdev = 0.794/0.794/0.794/0.000 ms
vagrant@b2:~$ exit
logout
Connection to 127.0.0.1 closed.
daisuke@daisukenoMac-mini OpenVPN % vagrant ssh a2
Last login: Tue Dec 31 06:38:37 2019 from 10.0.2.2
vagrant@a2:~$ 
vagrant@a2:~$ ping -c1 192.168.3.102
PING 192.168.3.102 (192.168.3.102) 56(84) bytes of data.
64 bytes from 192.168.3.102: icmp_seq=1 ttl=62 time=0.984 ms

--- 192.168.3.102 ping statistics ---
1 packets transmitted, 1 received, 0% packet loss, time 0ms
rtt min/avg/max/mdev = 0.984/0.984/0.984/0.000 ms
vagrant@a2:~$ 
vagrant@a2:~$ exit
logout
Connection to 127.0.0.1 closed.
daisuke@daisukenoMac-mini OpenVPN %
```

# Issues/Notes

- It takes a lot of time when "vagrant halt" on A1 and B1. Maybe openvpn processes are preventing from shutdown.
- I learned that Ubuntu works with 256MB memory.

# References

- man openvpn
- https://www.vagrantup.com/docs/cli/halt.html
- https://sisidovski.hatenablog.com/entry/2015/07/07/072150

