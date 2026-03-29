Dirtywave M8 tracker has the ability to control playback, trigger phrases and activate other commands via the Launchpad Pro among some other controllers simulating the firmware. The objective of this project is to simulate the Launchpad Pro via TouchOSC so a virtual monome grids can work as a M8 controller. This first iteration of the code merely provides control over mutes/solos, Live, Live-Que, Up, Down, Left, Right, Option, Edit, Shift, and Play.

We are essentially using Norns as a bridge between TouchOSC and the Dirtywave M8. While this script is being built for TouchOSC it will eventually be modified to accommodate physical grids devices as well. 

Current: Dirtywave M8 --USB--> Norns --Wireless Connection--> TouchOSC app. 

Soon: Dirtywave M8 --USB--> Norns --USB--> Monome Grids.

Connection: 

Using this requires use of the existing Toga monome norns script, and any script you want to use the TouchOSC controller with will require you to edit the script. M8_GRID-BRIDGE does not require script edits to ensure Toga is compatible. All of the instructions for Toga setup can be found via the Toga github page. Following the standard connections for OSC - use UDP as your Connection 1, your Host IP address, Send Port 10111, Receive Port 8002. 

