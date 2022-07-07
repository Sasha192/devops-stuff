Issues:

1. application-1 does not see another application-2 via dns name (ClusterIP)

- check that containers can resolve names:
```
POD_NAME=$(kubectl apply -f busybox:curl) 
kubectl exec "$POD_NAME" -- curl google.com
kubectl exec "$POD_NAME" -- curl google.com
```
- if DNS resolving failed, check that CoreDNS services work. The below snippet restarts the kube-system namespace
```
kubectl -n kube-system rollout restart deploy
```
- if that did not help, check calico is running properly on each node.
    - in my case there was an issue with calico connectivity to the master-node
    - specifying the [IP_DETECTION_METHOD](https://projectcalico.docs.tigera.io/networking/ip-autodetection) helped me.
    - my case:
```
ifconfig
kubectl set env daemonset/calico-node -n kube-system IP_AUTODETECTION_METHOD=interface=enp0s3
```

/// i had to look into [this](https://kienmn97.medium.com/handling-errors-while-deploying-kubernetes-cluster-on-vm-cluster-with-calico-network-710e3b122086) 🤣

