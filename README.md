### Various DevOps Scripts:

Issues:

- Could not import functions from another script
  - They are only imported, when specifying manually before running the script
- Proper Error handling
- Both long and short options

What is done
- OpenVPN:
    - [x] setting up OpenVPN Cluster with one server
      - TODO: client .ovpn does not work properly
      - Look into logs: `tail -f /var/log/syslog` 
    - [ ] setting up HA OpenVPN Cluster in the same subnet
    
