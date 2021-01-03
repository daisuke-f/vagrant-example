# Summary

- Single firewall DMZ example
- A proxy server and Web server in DMZ
- External network is reachable only from proxy server

# Network overview

<?xml version="1.0" encoding="UTF-8" standalone="no"?><svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" contentScriptType="application/ecmascript" contentStyleType="text/css" height="476px" preserveAspectRatio="none" style="width:505px;height:476px;" version="1.1" viewBox="0 0 505 476" width="505px" zoomAndPan="magnify"><defs><filter height="300%" id="f0" width="300%" x="-1" y="-1"><feGaussianBlur result="blurOut" stdDeviation="2.0"/><feColorMatrix in="blurOut" result="blurOut2" type="matrix" values="0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 .4 0"/><feOffset dx="4.0" dy="4.0" in="blurOut2" result="blurOut3"/><feBlend in="SourceGraphic" in2="blurOut3" mode="normal"/></filter></defs><g><text fill="#000000" font-family="Serif" font-size="11" lengthAdjust="spacingAndGlyphs" textLength="0" x="88" y="15.2104"/><text fill="#000000" font-family="Serif" font-size="11" lengthAdjust="spacingAndGlyphs" textLength="0" x="88" y="128.0151"/><text fill="#000000" font-family="Serif" font-size="11" lengthAdjust="spacingAndGlyphs" textLength="23" x="65" y="243.6245">dmz</text><text fill="#000000" font-family="Serif" font-size="11" lengthAdjust="spacingAndGlyphs" textLength="83" x="5" y="256.4292">192.168.1.0/24</text><text fill="#000000" font-family="Serif" font-size="11" lengthAdjust="spacingAndGlyphs" textLength="45" x="43" y="359.2339">internal</text><text fill="#000000" font-family="Serif" font-size="11" lengthAdjust="spacingAndGlyphs" textLength="83" x="5" y="372.0386">192.168.2.0/24</text><rect fill="#FEFECE" filter="url(#f0)" height="5" style="stroke:#A80036;stroke-width:1.0;" width="305" x="93" y="237.3164"/><rect fill="#FEFECE" filter="url(#f0)" height="5" style="stroke:#A80036;stroke-width:1.0;" width="404" x="93" y="352.9258"/><path d="M146.5,86.707 L146.5,121.707 " fill="none" style="stroke:#A80036;stroke-width:1.0;"/><path d="M146.5,121.707 L146.5,163.1094 " fill="none" style="stroke:#A80036;stroke-width:1.0;"/><path d="M143,195.9141 L143,237.3164 " fill="none" style="stroke:#A80036;stroke-width:1.0;"/><text fill="#000000" font-family="Serif" font-size="11" lengthAdjust="spacingAndGlyphs" textLength="79" x="64" y="220.4233">192.168.1.101</text><path d="M150,195.9141 L150,234.3164 A4,4 0 0 1 150,246.3164 L150,352.9258 " fill="none" style="stroke:#A80036;stroke-width:1.0;"/><text fill="#000000" font-family="Serif" font-size="11" lengthAdjust="spacingAndGlyphs" textLength="79" x="110.5" y="336.0327">192.168.2.101</text><path d="M249.5,242.3164 L249.5,278.7188 " fill="none" style="stroke:#A80036;stroke-width:1.0;"/><text fill="#000000" font-family="Serif" font-size="11" lengthAdjust="spacingAndGlyphs" textLength="79" x="210" y="261.8257">192.168.1.102</text><path d="M348.5,242.3164 L348.5,278.7188 " fill="none" style="stroke:#A80036;stroke-width:1.0;"/><text fill="#000000" font-family="Serif" font-size="11" lengthAdjust="spacingAndGlyphs" textLength="79" x="309" y="261.8257">192.168.1.103</text><path d="M447.5,357.9258 L447.5,394.3281 " fill="none" style="stroke:#A80036;stroke-width:1.0;"/><text fill="#000000" font-family="Serif" font-size="11" lengthAdjust="spacingAndGlyphs" textLength="79" x="408" y="377.4351">192.168.2.102</text><path d="M116.2277,52.2596 C119.5288,44.8043 126.852,43.5415 131.6785,50.6402 C134.9088,42.626 141.8277,39.8869 148.4414,46.8546 C154.1726,40.8 161.4171,43.5541 163.566,50.8984 C168.8933,44.8213 174.2326,43.5768 178.504,51.9871 C186.3898,55.2202 188.5235,61.1956 181.5932,67.3986 C185.2827,72.219 184.2174,77.3771 177.975,79.1357 C176.4967,87.6607 169.8289,90.6655 163.1062,84.4124 C160.8695,91.9585 153.6322,95.623 147.5943,88.4065 C141.7262,94.4812 135.008,92.8641 132.8196,84.6117 C126.9159,91.5363 119.906,89.6976 118.0925,80.8037 C110.6023,78.2158 107.7379,73.0969 113.2039,66.1783 C108.4375,60.0928 108.6436,55.662 116.2277,52.2596 " fill="#FEFECE" filter="url(#f0)" style="stroke:#A80036;stroke-width:1.0;"/><text fill="#000000" font-family="Serif" font-size="11" lengthAdjust="spacingAndGlyphs" textLength="47" x="123" y="69.1128">external</text><rect fill="#FEFECE" filter="url(#f0)" height="32.8047" style="stroke:#A80036;stroke-width:1.0;" width="71" x="111" y="163.1094"/><text fill="#000000" font-family="Serif" font-size="11" lengthAdjust="spacingAndGlyphs" textLength="51" x="121" y="183.3198">firewall1</text><rect fill="#FEFECE" filter="url(#f0)" height="32.8047" style="stroke:#A80036;stroke-width:1.0;" width="59" x="220" y="278.7188"/><text fill="#000000" font-family="Serif" font-size="11" lengthAdjust="spacingAndGlyphs" textLength="39" x="230" y="298.9292">proxy1</text><rect fill="#FEFECE" filter="url(#f0)" height="32.8047" style="stroke:#A80036;stroke-width:1.0;" width="50" x="323.5" y="278.7188"/><text fill="#000000" font-family="Serif" font-size="11" lengthAdjust="spacingAndGlyphs" textLength="30" x="333.5" y="298.9292">web1</text><rect fill="#FEFECE" filter="url(#f0)" height="32.8047" style="stroke:#A80036;stroke-width:1.0;" width="55" x="420" y="394.3281"/><text fill="#000000" font-family="Serif" font-size="11" lengthAdjust="spacingAndGlyphs" textLength="35" x="430" y="414.5386">node1</text><!--MD5=[d41d8cd98f00b204e9800998ecf8427e]--></g></svg>

## Firewall rules

|From    |To      |Accepted|Note    |
|:-------|:-------|:-------|:-------|
|external|web1    |Yes     |via firewall1 NAT|
|external|dmz     |No      |        |
|external|internal|No      |        |
|proxy1  |external|Yes     |        |
|dmz     |external|Partialy|via proxy1, web only|
|dmz     |internal|No      |        |
|internal|external|Partialy|via proxy1, web only|
|internal|dmz     |Yes     |        |

# Test

```
# initialized
vagrant up

# external to web1: Accepted
curl http://localhost:10080/

# internal to external without proxy: Rejected
vagrant ssh node1 --command "curl https://api.twilio.com/"

# internal to external with proxy: Accepted
vagrant ssh node1 --command "curl --proxy http://192.168.1.102:3128 https://api.twilio.com/"

# internal to dmz: Accepted
vagrant ssh node1 --command "curl http://192.168.1.103"
```


# Test environment

- Host
  - macOS Catalina 10.15.7
  - VirtualBox 6.1.16
  - Vagrant 2.2.10
- Guest
  - VirtualBox instance (memory 256MB)
  - CentOS 7 (centos/7 v2004.01)
