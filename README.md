### Various DevOps Scripts:

TODO:
- [ ] make setting up be:
  - each OpenVPN client is accessible only via VPN
  - client-to-client
  - OpenVPN server is default gateway
  - how will it work with K8s and Calico CNI ?
  - Goal is: each OpenVPN server\client can 
  
- [ ] make setting up executable via Ansible
- [ ] setting up HA OpenVPN Cluster in the same subnet


Issues:

- Could not import functions from another script
  - They are only imported, when specifying manually before running the script
- Proper Error handling
- Both long and short options

What is done
- OpenVPN:
    - [ ] setting up OpenVPN Cluster with one server

    
