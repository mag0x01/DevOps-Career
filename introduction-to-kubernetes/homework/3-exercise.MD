## Prerequisite

You'll need a Kubernetes (K8s) cluster for the homework.

**You can use the iac cluster but delete it at the end of the day**



## Extra Exercise

### Scenario

A development team has an issue with their application and can't identify what/which headers their service is receiving. The request helpm from the DevOps team to identify the headers that received on the server side.

A colleague recommended the following [tool](https://github.com/Ealenn/Echo-Server) in order to check the headers which are received on the server side. Their application is exposed to the public internet so you need to simulate the same behavior by using the tools.

Info: Because the project lacks a reverse proxy for the cluster, you'll have to map the tool to the port of a node (NodePort) and create a LB to externally access it.

Note: The project has a weird rule about the reusage of Dockerfiles due to business constrains so you'll have to create your own.