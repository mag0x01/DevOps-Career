# java-maven-app

This repository is for the building a Java app using Maven.

The repository contains a simple Java application which outputs the string
"Hello world!" and is accompanied by a couple of unit tests to check that the
main application works as expected. The results of these tests are saved to a
JUnit XML report.



# **Assignment**

Create 2 Linux VMs using the provided Vagrantfile

Install Jenkins on one VM

Create one Free-Style Jenkins job using the Jenkins GUI that will:

​	•**Clone** the HelloWorld Java app (it's inside this GitLab repo)

​	•**Build** app and execute tests using Maven

​	•**Publish JUnit tests** result (located under **target/surefire-reports/\*.xml** )



Create a pipeline job that will have 3 stages (Clone,Build,Test) and will do the same as the Free-Style job

Create the same Free-Style job using DSL script 

Configure the second VM as a Jenkins node and connect it to the master node

Modify the pipeline to execute on the second node





## Deliverables

You should send an archive to your mentor containing the fallowing:

- the xml corresponding to the freestyle job
- the jenkinsfile for your pipeline
- the  dsl script
- a screenshot with your second node configuration



## OPTIONAL

Given the fallowing picture try to create the jenkinsfile associated with it:

![pipeline.png](homework/img/pipeline.png)

- Sequential Stage2 should be optional and executed only when a **string paramete**r (let's call it optional) **equals "execute"** 
- Sequential Stage3 should fail but should not stop the execution of the pipeline
- Status of the entire pipeline should be unstable

