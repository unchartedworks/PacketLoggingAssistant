Packet Logging Assistant
======================

iOS does not support packet logging directly. With Packet Logging Assistant, you can use Wireshark to log cellular network/Wi-Fi network packets from an iOS device.
You can log all of packets even network handover occurs, for instance, network switches from 3G to Wi-Fi or Wi-Fi to 3G. 

Download Packet Logging Assistant for OS X 10.8 and later


[PacketLoggingAssistant.dmg](http://www.unchartedworks.com/download/PacketLoggingAssistant-OSX-intel-64-bit.dmg)

###Important
If you haven’t installed Xcode, please install Xcode.
It requires OS X 10.8 or later.
I strongly suggest you to install the latest Wireshark, the old Wireshark can’t always display network interface list correctly.

[http://www.wireshark.org/download.html](http://www.wireshark.org/download.html)

###How to use it?

1.Start Packet Logging Assistant

![](http://www.unchartedworks.com/pla/files/pasted-graphic.jpg)

2.Connect your iPhone to your Mac

3.Start Wireshark and select the network interface rvi0. (it depends on how many iOS devices connected to your Mac) 
![](http://www.unchartedworks.com/pla/files/screen-shot-2013-07-14-at-18.20.53.png)

If you can’t see rvi0, you can try to disconnect your iOS device and connect it again.
If you have multiple devices, you might see rvi0, rvi1, rvi2 …, just select the device you want to log packets.

4.Click Start button of Wireshark to log packets

![](http://www.unchartedworks.com/pla/files/screen-shot-2013-07-14-at-18.36.59.png)
