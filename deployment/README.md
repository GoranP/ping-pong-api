# Deploy Ping Pong application

Single YAML file declares following:

- create kubernetes service
- deploy pingpong application in high availability mode
- create ingress and open /ping URL to the public

Application is deployed in HA mode spreading two pods on two different availability zones using `podAntiAffinity` directive in deployment.
Ping Pong application is built and available with public image `goranpp/pingpong:latest`

Deployment, service and ingress are in one file for the sake of simplicity.
Everything is deployed in default namespace.

Deploy and expose /ping URL run following:
```
kubectl apply -f deployment.yaml 
```

Get quick check of deployment with:
```
kubectl get pods -A
```

Result should be something similar to the following:
```
NAMESPACE       NAME                                        READY   STATUS      RESTARTS   AGE
default         pingpong-deployment-77757cdfcd-fqzp4        1/1     Running     0          105m
default         pingpong-deployment-77757cdfcd-gr2p8        1/1     Running     0          105m
ingress-nginx   ingress-nginx-admission-create-6brph        0/1     Completed   0          106m
ingress-nginx   ingress-nginx-admission-patch-9rjc9         0/1     Completed   0          106m
ingress-nginx   ingress-nginx-controller-57b7568757-ttmwz   1/1     Running     0          106m
kube-system     aws-node-45n59                              2/2     Running     0          3h1m
kube-system     aws-node-tvct5                              2/2     Running     0          3h1m
kube-system     coredns-5fd78d9876-4bxgg                    1/1     Running     0          3h1m
kube-system     coredns-5fd78d9876-nm5wd                    1/1     Running     0          3h1m
kube-system     kube-proxy-5bp66                            1/1     Running     0          3h1m
kube-system     kube-proxy-m799r                            1/1     Running     0          3h1m
```

To get ingress ntrypoint run:
```
kubectl get ingress
```
Result should be similar to following:
```
NAME           CLASS    HOSTS   ADDRESS                                                                   PORTS   AGE
ping-ingress   <none>   *       a719fd8c430e44ad4b7679bad805434b-1009771493.eu-west-2.elb.amazonaws.com   80      106m
```

Column ADDRESS is DNS name of the entrypoint of application.

Verify that application is working well:

```
curl a719fd8c430e44ad4b7679bad805434b-1009771493.eu-west-2.elb.amazonaws.com/ping
"pong"
```


