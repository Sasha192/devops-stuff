# OpenVPN server setup
###Not completed:

- openvpn_CA_sign_server_certificate.sh
- openvpn_server_add_client.sh

1. need to make it idempotent and fail resilient ? or
2. just remove the folder and start again ? 

### OpenVPN Server Setting Up:

- stage 1 -- **Prerequisites and Infrastructure initialization**
  - installs all the prerequisites
  - initializes public-key infrastructure
  - creates request to the CA for signing
  - sends the request to the CA for signing
 

- stage 2 -- **CA signs the certificates**
    - CA signs the OpenVPN server certificate and sends signed certificate back
    - CA sends its own certificate to the OpenVPN server

- stage 3 -- **Correct location of .crt and .key files**
    - creates additional layer of security by creating pre-shared static key,
      so that we add an extra HMAC signature to all
      SSL/TLS handshake packets for integrity verification
    - that key will be included into all our certificates

- stage 4 -- **Extra security layer**
    - creates additional layer of security by creating pre-shared static key, 
      so that we add an extra HMAC signature to all 
      SSL/TLS handshake packets for integrity verification
    - that key will be included into all our certificates

- stage 5 -- **Importing pre-created server.conf**

- stage 6 -- **Network configuration**
    - Setting up traffic forwarding
    - Setting up firewall
    
### OpenVPN Server Start Up
- run **openvpn_run.sh**

