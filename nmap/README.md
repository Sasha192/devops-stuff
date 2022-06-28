 

- running nmap with and without root rights will lead to different behavior
    - https://nmap.org/man/ru/man-host-discovery.html
    - *sP (Пинг сканирование). По умолчанию опцией -sP посылаются запрос на ICMP это ответ и TCP ACK пакет на порт 80. Когда используется непривилегированным пользователем, посылается только SYN пакет (используя системные вызов connect) на порт 80 целевой машины. Когда привилегированный пользователь производит сканирование целей локальной сети, то используются ARP запросы до тех пор, пока не будет задано --send-ip*
    - если на сервере enabled firewall, то он может сбрасывать SYN пакеты, поскольку может посчитать эти действия, как port scanning
    
- https://nmap.org/book/man-port-scanning-techniques.html
