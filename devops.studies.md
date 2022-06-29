
## Questions to consider:

### 2nd block:

- [ ] client-to-client behaviour, when openvpn server is off  
> When we have `client-to-client` configuration,  clients ***see*** each other through the OpenVPN server.

> 1. The ping request message is sent from client1 to the OpenVPN server
> 2. The OpenVPN server forwards the message to client2
> 3. client2 sends back a ping reply message, again to the server
> 4. The OpenVPN server forwards the ping reply back to the client1

<div style="text-align: right"> &copy; Mastering OpenVPN </div>


- [ ] difference between `tun` and `tap` interfaces
- [ ] what is `tun` interface destination ?
> [possible answer](https://stackoverflow.com/questions/36375530/what-is-the-destination-address-for-a-tap-tun-device)
- [ ] make OpenVPN-Server be default gateway for OpenVPN client
> [openvpn-client-override-default-gateway-for-vpn-sever](https://serverfault.com/questions/819339/openvpn-client-override-default-gateway-for-vpn-sever);

> [how-to-set-the-default-gateway-in-linux](https://www.howtogeek.com/799588/how-to-set-the-default-gateway-in-linux/)

> [Add-or-Change-the-Default-Gateway-in-Linux](https://www.wikihow.com/Add-or-Change-the-Default-Gateway-in-Linux)

> [set-my-linux-box-as-a-router-to-forward-ip-packets](https://askubuntu.com/questions/227369/how-can-i-set-my-linux-box-as-a-router-to-forward-ip-packets)

> [IP-Masquerade-HOWTO](https://tldp.org/HOWTO/IP-Masquerade-HOWTO/)

> [set_up_a_NAT_router_on_a_Linux](https://how-to.fandom.com/wiki/How_to_set_up_a_NAT_router_on_a_Linux-based_computer)

> [iptables-forwarding-between-two-interface](https://serverfault.com/questions/431593/iptables-forwarding-between-two-interface)

- [ ] [What is the jumphost and how it is different from a firewall or VPN](https://www.quora.com/What-is-a-jump-host-How-is-it-different-from-a-firewall-and-a-VPN-connection)  
- [ ] [K8s Network Deep Dive](https://itnext.io/kubernetes-network-deep-dive-7492341e0ab5)


### 1st block
- https://www.cyberciti.biz/faq/tcpdump-capture-record-protocols-port/ -- tcpdump
- https://askubuntu.com/questions/530088/ufw-for-openvpn -- ufw for openvpn
- https://www.digitalocean.com/community/tutorials/how-to-set-up-a-firewall-with-ufw-on-ubuntu-14-04 -- ufw on Ubuntu


- make django \ flask web interface to make a requests for a crt


- 
