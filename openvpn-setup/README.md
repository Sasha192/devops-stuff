# OpenVPN server setup
###Not completed

- stage 1: 
  - installs all the prerequisites
  - initializes public-key infrastructure
  - creates request to the CA for signing
  - sends the request to the CA for signing
 

- stage 2
    - CA signs the OpenVPN server certificate and sends signed certificate back
    - CA sends its own certificate to the OpenVPN server


- stage 3
    - creates additional layer of security by creating pre-shared static key, 
      so that we add an extra HMAC signature to all 
      SSL/TLS handshake packets for integrity verification
      
    - that key will be included into all our certificates
