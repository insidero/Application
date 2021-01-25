## Description
In this project mongo and nodejs are connected using minikube. Network policy is created to ensure security using `calico` plugin which restricts the access to mongo POD except for nodejs, nodejs POD can access the mongo container. `BusyBox` is used to test the connection to the mongo POD, which it should fail.

### Deploment using Kubernetes yaml files
It contains all the kubernetes yaml files. To start the minikube in `MACOS` enviorment use this command:

`minikube start --memory=2048 --driver=hyperkit --network-plugin=cni --cni=calico`

Check whether the calico installation is successful with this command:

`kubectl get pods -l k8s-app=calico-node -n kube-system`

After the POD is running then use these command to deploy the nodejs and mongodb on kubernetes

1- `cd deployment`

2- `kubectl apply -f mongo/`

3- `kubectl apply -f nodejs/`

4- `kubectl apply -f policy/`

Then get the minikube ip by using the command:

`minikube ip` 

then copy the `minikubeip:30007` and paste it to the browser to see the app running

If you wish to serve it on the localhost port forward it to the localhost by using any of these commands:

`kubectl port-forward service/nodejs 3000:3000`

`kubectl port-forward `nodejsPodName` 3000:nodejs`

Then run the busy box image to see whether the mongo container is accessible or not:

`kubectl run access --rm -ti --image busybox /bin/sh`

after that use `telnet mongo 27017` to see if it can talk to mongo or not

### Helm-chart
Use `helm install application ./helm-chart   ` command to run the helm.

The default values are saved in `values.yaml` file.

### Dockerfile
It is a multistage dockerfile using nodejs-alpine as the base image, This strategy is used to minimize the conatiner size and a new user is created to insure the security of the container so that whenever somebody ssh into the container, it won't have the root priviliges.

### Folder Structure

```
Assignment
├── Readme.md
├── deployment
│   ├── mongo
│   │   ├── deployment.yml
│   │   ├── pvc.yml
│   │   └── service.yml
│   ├── nodejs
│   │   ├── deployment.yml
│   │   └── service.yml
│   └── policy
│       ├── allow-policy.yml
│       └── deny-policy.yml
├── dockerfile
├── helm-chart
│   ├── Chart.yaml
│   ├── charts
│   ├── templates
│   │   ├── NOTES.txt
│   │   ├── _helpers.tpl
│   │   ├── deployment.yaml
│   │   ├── network-policy.yaml
│   │   ├── pvc.yaml
│   │   ├── service.yaml
│   │   └── test
│   │       └── test-connection.yaml
│   └── values.yaml
└── node-easy-notes-app
```
### STEPS for Assignment that were followed
1- kubectl get pods -l k8s-app=calico-node -n kube-system

2- helm install application ./helm-chart

3- kubectl port-forward service/nodejs 3000:3000

4- curl --data "title=my very first note &content=I am writing a note" http://localhost:3000/notes

5- curl http://localhost:3000/notes

6- kubectl run access --rm -ti --image busybox /bin/sh

7- timeout 5 telnet mongo 27017