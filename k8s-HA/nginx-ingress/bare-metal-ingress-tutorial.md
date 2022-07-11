### TODO: specify why do we need all this things

### deploy the nginx-ingress bare-metal
```
kubectl apply -f nginx-ingress-deploy.yaml
```

### specify External IPs for ingress controller:
```
kubectl get nodes -o wide
```

#### my case
    - 192.168.31.154 
    - 192.168.31.248
    - 192.168.31.94
    - 192.168.31.247


### label each node you want to run ingress-controller on it:
```
kubectl label node k8s-master-node run-ingress-nginx=true
```

### make corresponding changes to the nginx-ingress-patch.yaml and apply them
```
kubectl -n ingress-nginx patch deployment/ingress-nginx-controller --patch "$(cat nginx-ingress-patch.yaml)"
```
