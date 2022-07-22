# Setting up your lab environment

### Introduction

In this tutorial we are going to install Jenkins on Ubuntu virtual machine hosted on Windows.



#### Prerequisites

- VirtualBox
- Vagrant


### VirtualBox Installation

VirtualBox is a powerful x86 and AMD64/Intel64 [virtualization](https://www.virtualbox.org/wiki/Virtualization) product.

*If you already have VirtualBox installed on your PC make sure that you are using the latest stable release version. If not please proceed with the installation.*

Go to [virtualbox.org](https://www.virtualbox.org/wiki/Downloads)  select Widows hosts under platform packages.  Run the installer and follow the prompts to complete the installation by clicking the NEXT button.



### Vagrant

##### **<u>Installation</u>**

Vagrant is a multi-platform command line tool for creating  and managing lightweight, reproducible and portable virtual environments.

Go to the [Vagrant downloads page](https://www.vagrantup.com/downloads) and get the Windows installer and proceed with the installation.

The installer will automatically add `vagrant` to your system path so that it is available in terminals. If it is not found, please try logging out and logging back in to your system (this is particularly necessary sometimes for Windows).

As stated in the [official documentation](https://www.vagrantup.com/docs/installation) for using  VirtualBox on Windows, you must ensure that Hyper-V is not enabled on Windows. You can turn off the feature by running this Powershell command:

```
Disable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-All
```

You might have to reboot your machine for the changes to take effect.

After installation is completed you can check it out by opening a terminal and typing this command:

```
vagrant -v
```



**<u>Creating the Ubuntu virtual machine</u>**

- clone this repo

- go to labEnv directory where the Vagrantfile is located

- open a terminal (git bash for example)

- execute the fallowing command

  ```
  vagrant status
  ```

  The output should look something like this:

  ```
  $ vagrant status
  Current machine states:

  jenkinsmain               not created (virtualbox)
  jenkinsnode1              not created (virtualbox)

  This environment represents multiple VMs. The VMs are all listed
  above with their current state. For more information about a specific
  VM, run `vagrant status NAME`.

  ```

- start the jenkinsmain virtual machine

  ```
  vagrant up jenkinsmain
  ```



- connect to the jenkinsmain vm

  ```
  vagrant ssh jenkinsmain
  ```



  You should be able to see your vm in VirtualBox:

  ![virtualbox.png](labEnv/img/virtualbox.png)

Now you are ready to move to the next step and install Jenkins.



<u>**Other usefull Vagrant commands:**</u>

| VagrantCommand    | Description                                                  |
| ----------------- | ------------------------------------------------------------ |
| $ vagrant ssh     | SSH into virtual machine                                     |
| $ vagrant up      | Start virtual machine                                        |
| $ vagrant halt    | Halt/stop virtual machine                                    |
| $ vagrant destroy | Destroy your virtual machine. The source code and the content of the  data directory will remain unchanged. Only the VirtualBox machine  instance will be destroyed. You can build your machine again with the  'vagrant up' command |
| $ vagrant reload  | Reload the virtual machine. Useful when you need to change network or synced folder settings |



For more information about Vagrant check the official documentation [here](https://www.vagrantup.com/docs).



### Install Jenkins

#### Prerequisites

- Minimum hardware requirements:

  - 256 MB of RAM

  - 1 GB of drive space (although 10 GB is a recommended minimum if running Jenkins as a Docker container)



- Software requirements

  - Jenkins requires Java in order to run, yet certain distributions don’t include this by default and  [some Java versions are incompatible](https://www.jenkins.io/doc/administration/requirements/java/) with Jenkins
  - We will use [OpenJDK](https://openjdk.java.net/) in this guide



#### Install Java11

Make sure you are connected to the jenkinsmain vm

```
vagrant ssh jenkinsmain
```

Update the repositories

```
sudo apt update
```

Search of all available packages:

```
sudo apt search openjdk
```

Pick one option and install it:

```
sudo apt install openjdk-11-jdk
```

The result must be something like:

```
vagrant@jenkinsmain:~$ java -version
openjdk version "11.0.13" 2021-10-19
OpenJDK Runtime Environment (build 11.0.13+8-Ubuntu-0ubuntu1.18.04)
OpenJDK 64-Bit Server VM (build 11.0.13+8-Ubuntu-0ubuntu1.18.04, mixed mode, sharing)

```



#### Install Jenkins

Install Jenkins latest [LTS (Long-Term Support) release](https://www.jenkins.io/download/lts/).

```
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null

echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null

sudo apt install ca-certificates

sudo apt-get update

sudo apt-get install jenkins
```



This package installation will:

- Setup Jenkins as a daemon launched on start. See `/etc/init.d/jenkins` for more details.
- Create a ‘jenkins’ user to run this service.
- Direct console log output to the file `/var/log/jenkins/jenkins.log`. Check this file if you are troubleshooting Jenkins.
- Populate `/etc/default/jenkins` with configuration parameters for the launch, e.g `JENKINS_HOME`
- Set Jenkins to listen on port 8080. Access this port with your browser to start configuration.



#### Start Jenkins

In order to start Jenkins execute the fallowing command:

```
sudo /etc/init.d/jenkins start
```

The output should look something like this:

```
vagrant@jenkinsmain:~$ sudo /etc/init.d/jenkins start
Correct java version found
[ ok ] Starting jenkins (via systemctl): jenkins.service.
```

Open a browser on you local computer and go to vmIP:8080. In our case it will be http://192.168.10.10:8080/

![unlock.png](labEnv/img/unlock.png)



In order to login you need to take the administrator password using this command:

```
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```



Install all recommended plugins .

![install_plugins.png](labEnv/img/install_plugins.png)



Make sure you create a new user and provide a password that you will remember.

![create_admin.png](labEnv/img/create_admin.png)

After you manage to successfuly login you should be able to see Jenkins GUI:

![welcome.png](labEnv/img/welcome.png)
