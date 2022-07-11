### TODO: specify why do we need all this things

#### deploy the nginx-ingress bare-metal
```
kubectl apply -f nginx-ingress-deploy.yaml
```

#### specify External IPs for ingress controller:
```
kubectl get nodes -o wide
```

#### my case
    - 192.168.31.154 
    - 192.168.31.248
    - 192.168.31.94
    - 192.168.31.247


#### label each node you want to run ingress-controller on it:
```
kubectl label node ubuntu1 runingressnginx=true
```

#### make corresponding changes to the ingress-svc-patch-externalIps.yaml and apply them

- patch to the ingress svc
```
kubectl -n ingress-nginx patch svc ingress-nginx-controller --patch "$(cat ingress-svc-patch-externalIps.yaml)"
kubectl get svc  ingress-nginx-controller -n ingress-nginx
```

- patch to the ingress-nginx deployment
```
kubectl -n ingress-nginx patch deployment/ingress-nginx-controller --patch "$(cat nginx-ingress-patch-nodeSelector.yaml)"
kubectl -n ingress-nginx patch deployment/ingress-nginx-controller --patch "$(cat nginx-ingress-patch-tolerations.yaml)"
```
