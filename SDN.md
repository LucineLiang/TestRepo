# Software Defined Network (SDN)
#### 1. What we expect in SDN
* Isolation
* Virtualized and programmable
* Open development environment
* Flexible definitions of a flow

#### 2. __Key features of SDN__
* __Separates control plane and data plane entities__
* Runs control plane software on __general purpose__ hardware
* Has __programmable__ data planes
* Control Software

#### 3. Benefits of SDN
* Simpler control with greater __flexibility__
* Programmability
* Lower Total Cost of Ownership

#### 4. General structure of SDN (top-down)
* SDN controller (software)
* OpenFlow (one of SDN protocols)
* SDN switch (hardware)

> Each network element contains a flow table that is computed and distributed by a logically centralized controller.

> The datapath of an OpenFlow Switch consists of a Flow Table, and an action associated with each flow entry.

#### 5. An entry in the Flow-Table has three fields
* A rule that defines the flow, i.e., the packets that is classified to be part of the flow. The rule consists of mainly field in the packet header.
* The action, which defines how the packets should be processed.
* Statistics, which keep track of the number of packets and bytes for each flow, and the time since the last packet matched the flow (to help with the removal of inactive flows).

#### 6. The three basic actions in the entry
* Forward this flow’s packets to a given port (or ports). 
> This allows packets to be routed through the network. In most switches this is expected to take place at line rate.
* Encapsulate and forward this flow’s packets to a controller. 
> Packet is delivered to Secure Channel, where it is encapsulated and sent to a controller. Typically used for the first packet in a new flow, so a controller can decide if the flow should be added to the Flow Table. Or in some experiments, it could be used to forward all packets to a controller for processing.
* Drop this flow’s packets. 
> Can be used for security (firewall), to curb denial of service attacks, or to reduce spurious broadcast discovery traffic from end-hosts.

#### 7. OpenFlow abstraction

match+action: unifies different kinds of devices
* __Router__: 
    * match: longest destination IP prefix
    * action: forward out a link
* __Switch__:
    * match: destination MAC address
    * action: forward or flood
* __Firewall__:
    * match: IP addresses and TCP/UDP port numbers
    * action: permit or deny
* __NAT__:
    * match: IP address and port
    * action: rewrite address and port

#### 8. Packet Forwarding in OpenFlow
* Reactive flow insertion
> A non-matched packet reaches to OpenFlow switch, it is sent to the controller.
* Proactive flow insertion
> Flow can be inserted proactively by the controller to switches before packet arrives.

_Reference: https://subjects.ee.unsw.edu.au/tele4642/  http://yuba.stanford.edu/cs244wiki/index.php/Overview_
