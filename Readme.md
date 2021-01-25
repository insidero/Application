### Deployment Folder
It contains all the kubernetes yaml files. To start the minikube in `MACOS` enviorment use this command:
`minikube start --memory=2048 --driver=hyperkit --network-plugin=cni --cni=calico`
Check whether the calico installation is successful with this command:
`kubectl get pods -l k8s-app=calico-node -n kube-system`
After the POD is running then use these command to deploy the nodejs and mongodb on kubernetes
`cd deployment`
`kubectl apply -f mongo/`
`kubectl apply -f nodejs/`
`kubectl apply -f policy/`
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
Use `helm install nodejs` command to run the helm.
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