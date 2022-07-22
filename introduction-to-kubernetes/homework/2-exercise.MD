## Prerequisite

You'll need a Kubernetes (K8s) cluster for the homework.

**You can use the iac cluster but delete it at the end of the day**


## Exercise 1

Starting from the Pod exercise from yesterday do the following:
* Create a Deployment with a replica of 2
* Configure the Pod to require at least *200 Mb* and *0.2 CPU*
* Configure the Pod to not use more than *0.5 CPU*
* `default` namespace must be used here

## Exercise 2

Use the *Secret* and *ConfigMap* to configure the above deployment with the following:
* Use a custom html file for the nginx pods
* For the current nginx image, create a copy of it and tag it for your personal private repository (DockerHub); replace the image with the one from your private repository

## Exercise 3

Create a *Service* of type *NodePort* for the above deployment. The port used should be `8080`.

## Exercise 4

Create a Deployment `echo` with the following specifications:
* image used should be https://hub.docker.com/r/ealen/echo-server
* deployment should be in the `playground` namespace

Create a Service with ClusterIP for the above serivce. Check documentation for port.

## Exercise 5

Create a NetworkPolicy that denies all incoming requests in the `playground` namespace and allows only the `nginx` from the `default` namespace.
* check if you can do a curl from the `nginx` to `echo`


## Exercise 6

Create a Job that:
* runs a curl command against the `echo` service
* if the curl succedes output the following `Network Policy failed! I shouldn't be allowed!`
* if the curl fails output the following `Network Policy works! Echo is safe <3`

## Extra Exercise

Manually (UI) create a LB on Azure that:
* forwards requests to the worker nodes of K8s
* update the nginx configuration so that the requests are getting forwarded to the `echo` service
* the reponse of the request should come from the `echo`