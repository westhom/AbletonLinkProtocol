# Ableton Link protocol
In progress documentation/reversing of Ableton's new Link protocol (syncs the timing of multiple devices 
for jam sessions). Currently the protocol is built into Live beta, and Ableton is handing out a private
library to iOS developers on a case-by-case basis. I'm interested to learn about the protocol because I 
would like to program an Arduino or Raspberry Pi to incorporate my hardware synthesizer into a Link
session. Doesn't seem like there will be a platform-independent library any time soon.

## The Basics
Link is a UDP protocol that uses the multicast group 224.76.78.75 (last 3 octets spell "LNK" in ASCII), 
port 20808. Link clients join + leave the multicast group via IGMP.

## Packet Types
### Timeline packet
Sent continuously by all connected clients.

Sent by Live Beta: 

```
0000   5f 61 73 64 70 5f 76 01 01 05 00 00 52 7b 46 27
0010   65 45 53 3a 74 6d 6c 6e 00 00 00 18 00 00 00 00
0020   00 0c 35 00 00 00 00 00 4f 14 99 30 00 00 00 00
0030   06 2c 36 f4 73 65 73 73 00 00 00 08 52 7b 46 27
0040   65 45 53 3a 6d 65 70 34 00 00 00 06 0a 00 01 21
0050   fa f4
```

Sent by iPad app:

```
0000   5f 61 73 64 70 5f 76 01 01 05 00 00 6a 5b 3e 5b
0010   69 5c 6a 66 74 6d 6c 6e 00 00 00 18 00 00 00 00
0020   00 2d c6 c0 00 00 00 00 2b 5b 71 6b 00 00 00 01
0030   9d ec ea 72 73 65 73 73 00 00 00 08 6a 5b 3e 5b
0040   69 5c 6a 66 6d 65 70 34 00 00 00 06 c0 a8 00 a2
0050   f8 75
```

Below is the in-progress packet structure for the timeline packet. 
The disconnect packet uses the same header but only contains the client ID.
More information to come.

![](http://i.imgur.com/O9T3A68.png)

### Disconnect Packet
Sent right before a client leaves the multicast group.
```
0000   5f 61 73 64 70 5f 76 01 03 00 00 00 23 66 75 58
0010   5e 6b 28 2d
```

![](http://i.imgur.com/oLzkIVO.png)

## Wireshark Packet Dissector
When capturing data with wireshark, go to Tools->Lua->Evaluate and paste in the
provided lua script to get a basic reading of the timeline packet.

Useful wireshark filter: `ip.dst == 224.76.78.75 || ip.dst == 224.0.0.22`

## Help
I only have access to two copies of Live Beta, so progress is a bit slow in figuring out the nuances of the protocol. Any help would be awesome. A single packet dump of a Link session (with at least 1 iOS client) would be useful
