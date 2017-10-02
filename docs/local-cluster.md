# Setting Up a Local Cluster

These instructions assume you're working on a local cluster with Minikube, 
have Minikube and kubectl already installed, have all of the internally
dependent projects at the same path level in the file system, and are
currently in the Aether project folder.

Let's begin.

# Secrets, Whales, and trusting the Helmsman

First, let's make sure Docker and Kubernetes are running as expected. 
Assuming you're running this on a Mac, Docker can be run from the 
`/Applications` path. Next, Minikube needs to be started from the 
terminal. 

```
minikube start
```

Minikube will begin to initialize with the following message:

```
Starting local Kubernetes v1.7.0 cluster...
Starting VM...
Moving files into cluster...
Setting up certs...
Starting cluster components...
Connecting to cluster...
Setting up kubeconfig...
Kubectl is now configured to use the cluster.
```

Register our TLS certificate:
```
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout ~/nginx.key -out ~/nginx.crt -subj '/C=FI/L=Helsinki/O=Airi.ink/OU=Org/CN=localhost'
```

Save certificate and secret as a secret:
```
kubectl create secret generic nginx-cert --from-file=nginx.key --from-file=nginx.crt
```

Next, we need to export our Minikube Docker environment:

```
eval $(minikube docker-env)
```

The cluster can then be built by simply running:

```
make build-cluster
```

Then we need to set up the proxy, delete the proxy service, then re-establish the proxy 
service without the `LoadBalancer` configuration.

```
kubectl create -f deploy/proxy/proxy-service.yaml && kubectl delete service aether-proxy && kubectl expose deployment aether-proxy --type=NodePort --name=aether-proxy
```

Then we need to finally establish whether the proxy is running.
