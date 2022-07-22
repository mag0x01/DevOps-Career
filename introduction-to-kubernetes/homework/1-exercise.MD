## Prerequisite

You'll need a Kubernetes (K8s) cluster for the homework.

**You can use the iac cluster but delete it at the end of the day**


## Exercise 1

Create a namespace called *playground* with two customs labels (your choice):
  * Query the created resource and check where what's the key associated with the name of your namespace
  * Extra: check on the official documentation what *managedFields* stands for

## Exercise 2

Create an nginx pod in the namespace created above:
  * Use the full path for the image name
  * Define an environment variable for the nginx container, can be static (check k8s documentation for additional fields)
  * Check inside the container that the value was set
  * Extra: use a environment variable as an argument to the nginx container (check k8s documentation for additional fields)

## Exercise 3

Look at the events of the above pod  and identify what were the steps for that pod to be created (check kubectl events).

## Extra Exercise

Create a ServiceAccount *sa-logs* that can check the logs of the pods in *default* and *playground* namesaces only.
* Role and RoleBindings are required

Create a pod using the following docker image *https://hub.docker.com/r/bitnami/kubectl* and use the above ServiceAccount
* check the logs of a random pod in *default* and *playground* namespace
* check the logs of a random pod in *kube-system*. What happened?