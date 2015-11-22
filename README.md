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

```
0000   5f 61 73 64 70 5f 76 01 01 05 00 00 52 7b 46 27
0010   65 45 53 3a 74 6d 6c 6e 00 00 00 18 00 00 00 00
0020   00 0c 35 00 00 00 00 00 4f 14 99 30 00 00 00 00
0030   06 2c 36 f4 73 65 73 73 00 00 00 08 52 7b 46 27
0040   65 45 53 3a 6d 65 70 34 00 00 00 06 0a 00 01 21
0050   fa f4
```

Below is the in-progress packet structure for the timeline packet. 
The disconnect packet uses the same header but only contains the client ID.
More information to come.

![](http://i.imgur.com/sMDE8Re.png)

### Disconnect Packet
Sent right before a client leaves the multicast group.
```
0000   5f 61 73 64 70 5f 76 01 03 00 00 00 23 66 75 58
0010   5e 6b 28 2d
```



## Wireshark Packet Dissector
When capturing data with wireshark, go to Tools->Lua->Evaluate and paste in the
provided lua script to get a basic reading of the timeline packet.
