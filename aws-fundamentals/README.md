# AWS Fundamentals

# Table of Contents
- [AWS Fundamentals](#aws-fundamentals)
- [Table of Contents](#table-of-contents)
- [General Overview](#general-overview)
- [AWS Console and CLI](#aws-console-and-cli)
  - [Configuring the CLI](#configuring-the-cli)
  - [Using the CLI](#using-the-cli)
- [CloudFormation (CFN)](#cloudformation-cfn)
  - [CloudFormation Templates](#cloudformation-templates)
- [Identity and Access Management (IAM)](#identity-and-access-management-iam)
- [Elastic Cloud Compute (EC2)](#elastic-cloud-compute-ec2)
  - [Virtual Private Cloud (VPC)](#virtual-private-cloud-vpc)
  - [EC2 Instances](#ec2-instances)
  - [EC2 Billing and Spot Instances](#ec2-billing-and-spot-instances)
  - [EC2 Storage Options](#ec2-storage-options)
  - [EC2 AutoScaling](#ec2-autoscaling)
- [Elastic Load Balancing (ELB)](#elastic-load-balancing-elb)
- [Relational Database Service (RDS)](#relational-database-service-rds)
- [Elastic Container Service (ECS)](#elastic-container-service-ecs)
- [Simple Cloud Storage (S3)](#simple-cloud-storage-s3)
- [Other Services](#other-services)

# General Overview

AWS(Amazon Web Services) is a cloud service from Amazon, which provides various services in the form of building blocks. These building blocks cand be used in order to create and deploy any type of application in the cloud. AWS has IAAS, PAAS and SAAS offerings in order to facilitate the ease of infrastructure setup for each client need, and every type of application.

The "building blocks" provided by AWS encompass a wide area of technologies - starting from components that would normally be configured on an on-premise infrastructure (firewalls, routing setup, etc.) and going up to technology-specific configurations (for kubernetes, machine learning, etc.).

AWS operates on a pay-as-you-go basis, meaning that you only pay for what you use, as long as you use it. There are also some free offerings, which correlate certain components, as well as services that can be paid for in advance. But, generally speaking, the offerings will be pay-as-you-go.

One of the core functionalities of AWS is named EC2 (Elastic Cloud Compute), which allows the creation of *virtual servers (called EC2 instances)* capable of performing computational tasks.

The AWS ecosystem is split into different **regions** (according to the physical location of the hardware used to create resources), which are further split into **availability zones (AZs)** (split via independent data centers). This allows customers to deploy their application in a certain region on the globe - either to comply with local regulations, or to minimize access times to the resources. As an example, a valid AWS region is **eu-west-1** (which is located in Ireland), and an availability zone of this region is **eu-west-1b**.
# AWS Console and CLI

The simplest way one can interact with AWS is via its Management Console.

![AWS Console](static/Console.PNG)

The AWS Console is a web application which can be used to create any AWS resource by just choosing some options from the provided dropdowns, as well as filling up data in a few fields. This allows users to easily experiment with the AWS offerings, without putting too much effort into the automation side of things - this is further enhanced by the tutorials provided by AWS, and various courses on the internet, all of which rely on the Console. However, this is not the best approach for DevOps teams.

AWS also provides an API that can be accessed using some configured in the AWS Account. This API is used with the CLI (command-line interface) provided by AWS (**awscli**), which enables resource creation in a programmatic way. The API is also used by various third-party apps, which make configuring AWS resources even easier (terraform, for example).

## Configuring the CLI

Using the console only requires the browser (accessing https://console.aws.amazon.com/). The AWS CLI requires installation. Linux commands can be found below:
```
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
```
This will install the AWS CLI on your local machine, but it will have to be configured. The easiest way to do this is to run **aws configure**, which will prompt you for your Access Key, Secret Key (more on these two in the IAM section), default region name and default output format. After running this, two files will be populated - ~/.aws/credentials and ~/.aws/config (replace ~/ with %USERPROFILE%\ for Windows). They should look something like this:

**~/.aws/credentials**
```
[default]
aws_access_key_id=AKIAIOSFODNN7EXAMPLE
aws_secret_access_key=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
```
**~/.aws/config**
```
[default]
region=us-west-2
output=json
```

In this example, **[default]** refers to the profile we are using. When you initialize the AWS CLI, you will only have the default profile. A good practice is to setup different profiles (for different regions, different credentials - you might use this to access different environments, for example).

**~/.aws/credentials**
```
[default]
aws_access_key_id=AKIAIOSFODNN7EXAMPLE
aws_secret_access_key=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY

[user1]
aws_access_key_id=AKIAI44QH8DHBEXAMPLE
aws_secret_access_key=je7MtGbClwBF/2Zp9Utk/h3yCo8nvbEXAMPLEKEY
```
**~/.aws/config**
```
[default]
region=us-west-2
output=json

[profile user1]
region=us-east-1
output=text
```

The credentials file uses the same format for each profile, whereas in the config file you will have to specify the **profile** keyword. In order to use these profiles, you can append the **--profile *profile-name*** option to the command you are running. If you want this profile to be used without specifying it every single time, you can set the **AWS_PROFILE** environment variable.

## Using the CLI

The CLI command synopsis comes down to ```aws <command> <subcommand> [options and parameters]```. Generally speaking, ```<command> ``` refers to a module within the AWS ecosystem, whereas ```<subcommand>``` refers to an action on that specific module. For example, if we wanted to describe the EC2 instances currently present in the region from the config file, we can run ```aws ec2 describe-instances```. If we want to run this on a specific profile, we can use ```aws ec2 describe-instances --profile user1``` (more on **EC2** in an upcoming section).

# CloudFormation (CFN)

An alternative to using the CLI or Console for creating all the resources would be to use [CloudFormation](https://docs.aws.amazon.com/cloudformation/), which is an IaC tool that helps you define your infrastructure in a JSON/YAML format. While uploading the CFN file still has to be done via the console / CLI, it reduces the overall time spent to configure the tools (since finding any issues is easier in a code format).

There are three key concepts when it comes to CFN:
- Templates: these are the infrastructure config files that you will upload to AWS; they include all the details needed for creating your resources
- Stacks: all the resources from a template are organized into "stacks"; this merely represents a collection of resources created from a specific template
- Change sets: a summary of the proposed changes (you can generate this when updating a stack, for example)

The actual resource definition gets written into the **templates**, which get uploaded to AWS as a unit, in the form of **stacks**, whose changes (creates/updates/etc) can be seen via a **change set**.

## CloudFormation Templates

Generally speaking, the bare bones version of a template should include a **Resources** tag, which is mandatory. In this block, all the needed resources will be declared, along with their respective mandatory parameters (these differ from resource to resource, so the [documentation](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-template-resource-type-ref.html) will provide all the necessary details). Other than that, we can also use an **Outputs** tag to specify CloudFormation data that can be used in **other stacks** - for example, we might have one stack creating a set of networking-based resources, and a different stack needing to access those resources. In order to access these values, we will need to use the [intrinsic function](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/intrinsic-function-reference.html) ```Fn::ImportValue```. There are a number of useful intrinsic function, and their usage can be found in the documentation - the most used ones are ```Ref``` and the aforementioned ```Fn::ImportValue```.

For the following example, the types of resources do not matter *for now* - they will be discussed in a later section.

Sample template:
```
Description: VPC creation with outputs
Outputs:
  testIgwId:
    Description: IGW ID export
    Export:
      Name: test-igw-export
    Value: !Ref 'testIgw'
  testVpcId:
    Description: VPC ID export
    Export:
      Name: test-vpc-export
    Value: !Ref 'testVpc'
Resources:
  testVpc:
    Properties:
      CidrBlock: 10.11.0.0/16
      Tags:
        - Key: Name
          Value: VPC
    Type: AWS::EC2::VPC
  testIgw:
    Properties:
      Tags:
        - Key: Name
          Value: Internet Gateway
    Type: AWS::EC2::InternetGateway
  testVpcGatewayAttach:
    Properties:
      InternetGatewayId: !Ref 'testIgw'
      VpcId: !Ref 'testVpc'
    Type: AWS::EC2::VPCGatewayAttachment
```

Each resource will have a **logical ID** (*testVpc*, for example), which will later be used in conjunction with the other resources. We also need to specify the **type** of resource we're using, which will tell AWS what needs to be created.
Apart from the general configuration for the resources, you will see the ```!Ref``` intrinsic function, which fetches some resource-related data, depending on the resource. For example, for the **VPC** resource, the ```!Ref``` function would return *the AWS ID of the VPC*, which would later be used as a mandatory parameter in a different resource.

Another important parameter to note is **Tags** - this will be used by AWS to convey resource-specific data via de Console, CLI or API. For example, the ```Name``` tag will show us the resource name in the console. We can use this section to also fill out some other data that can later be used in filtering resources (for example, an ```Environment``` tag).

The ```Outputs``` section will need to have a *logical ID* for each output, and the *value* we need to export - this is the value that will show up in the ```aws cloudformation describe-stacks``` command. The *export* part is optional, but required for cross-stack references (as done in the following example - notice that we now have *two* templates, which will be used in two separate stacks).

Using an output can be seen in the template below:
```
Description: Output Test
Resources:
  testPublicSn:
    Properties:
      AvailabilityZone: eu-west-1a
      CidrBlock: 10.11.0.0/28
      MapPublicIpOnLaunch: true
      Tags:
        - Key: Name
          Value: test Public App Subnet
      VpcId: !ImportValue 'test-vpc-export'
    Type: AWS::EC2::Subnet
```

You will need to use the value passed to the ```Export.Name``` property in the output, and passing it to ```!ImportValue``` (which is the short form of ```Fn::ImportValue```).

In the resource documentation, you will often find passages describing what will happen while updating a certain parameter. These mean:
- "Update requires: No interruption": changing the parameter will not affect the reosurce in any way
- "Update requires: Some interruption": updating this parameter might cause some hiccups in the resource's efficiency (you might experience delay when doing some actions, etc)
- "Update requires: Replacement": the resource will have to be replaced - a new ID will be generated, and the old one will no longer be valid
# Identity and Access Management (IAM)

This part of the AWS ecosystem is responsible for authorizing users/services when it comes to AWS resources. When you first create an AWS account, you will be logged into the **root** account, which has full access to everything. Needless to say, not all users will need the same rights for all the resources, so their access needs to be managed accordingly, which is the job of [IAM](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/AWS_IAM.html).

The permissions are assigned under the form of **policies**. The policy can be applied directly to the users, user groups, role (these three are **identity-based policies**), or resources (**resource-based policy**). A policy can be inline (applying it to the given entity), or managed (in which you save a policy, and you can apply it afterwards; AWS has a couple of pre-defined managed policies, such as *Administrator Access*). You can find a sample policy below:
```
{
  "Version": "2012-10-17",
  "Id": "My Policy",
  "Statement": [{
    "Sid": "1",
    "Effect": "Allow",
    "Principal": {"AWS": ["arn:aws:iam::account-id:root"]},
    "Action": "s3:*",
    "Resource": [
      "arn:aws:s3:::mybucket",
      "arn:aws:s3:::mybucket/*"
    ]
  }]
}
```
With the exception of *"Id"* and *"Sid"*, all of the above parameters are mandatory. They signify the following - (*) means the param is manadatory:
- Version(\*): the policy version. it **has** to be 2012-10-17 for any new policy (there is also a version for 2008, but that should not be used, outside of legacy policies)
- Id: an identifier for the defined policy
- Statement(\*): a list of policy statements - these are the actual blocks that allow / deny access. By default, the access is blocked, unless otherwise specified (in simpler words, this works on a *whitelist* basis)
  - Sid: an identifier for the statement
  - Effect(\*): specifies whether to Allow or Deny the action
  - Principal(required in some circumstances): the entity that the statement pertains to (only for resource-based policies; it cannot be assigned to a user/role)
  - Action(\*): the requested action
  - Resource(required in some circumstances): the resource on which the action can be performed; this is not required for resource-based policies
  - Condition: optional parameter, in which we can specify a condition under which we will apply the policy

![Policy Types](static/Types_of_Permissions.png)

A policy can be assigned to created users. This will only allow the selected user to access the resources specified. While this provides granular control, it is better to assign policies to **user groups**. User groups basically aggregate similar user into only one group - for example, we might have a Dev group, and a DevOps group, which will need different permissions. Assigning a policy to a user group will reflect the policy permissions on all the users present in the group.

A policy can also be assigned to a role. A role is attached to AWS services instead of human users - this is useful for automation purposes, or if a service needs access to a different service in order to perform its functions.

# Elastic Cloud Compute (EC2)

[EC2](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/AWS_EC2.html) is one of the largest parts of the AWS ecosystem. The offering is targeted towards creating and managing **virtual computers** (in the form of *EC2 Instances*), as well as all the other components needed for them. Generally speaking, most of the regular hardware components that would usually be found on an *On-Premise* infrastructure will have a counterpart in the AWS ecosystem.

EC2 has components that handle the *networking* (VPC), *compute* (EC2 instances) and *storage* (EBS, Instance Storage) layers.
## Virtual Private Cloud (VPC)

The [VPC](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ec2-vpc.html) component of the AWS cloud defines the logical network separation of various resources within an account. At its core, a VPC encapsulates the infrastructure for a certain project - one account can have multiple VPCs (up to 5 per region). The VPC contains all the networking components necessary in splitting logical parts in an infrastructure (the first one being the VPC itself).

Whenever creating a VPC, you will need to specify a *CIDR* block - the smallest one uses a /28 netmask (16 IPv4 addresses), and the biggest one uses a /16 netmasc (65536 IPv4 addresses). This is the only required parameter for the VPC - you can optionally specifiy some DNS-related parameters, as well as the instance tenancy. The VPC will be created in the region you are currently connected to.

After creating the VPC, you can create [subnets](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ec2-subnet.html) - these will be sub-networks within your big network (VPC) where your instances will reside. The subnets can either be public or private, depending on how we want the instances to be accessed (instances added in a public subnet will automatically have a public IP assigned to them). While VPC spans a whole region, the subnets created within it will span availability zones - so, naturally, this will be a mandatory parameter when creating a subnet, along with the VPC id.

```
Description: VPC creation with subnets
Resources:
  testVpc:
    Properties:
      CidrBlock: 10.11.0.0/16
      Tags:
        - Key: Name
          Value: VPC
    Type: AWS::EC2::VPC
  testPublicSn:
    Properties:
      AvailabilityZone: eu-west-1a
      CidrBlock: 10.11.0.0/28
      MapPublicIpOnLaunch: true
      Tags:
        - Key: Name
          Value: test Public App Subnet
      VpcId: !Ref 'testVpc'
    Type: AWS::EC2::Subnet
  testPrivateSn:
    Properties:
      AvailabilityZone: eu-west-1b
      CidrBlock: 10.11.0.16/28
      Tags:
        - Key: Name
          Value: test Private App Subnet
      VpcId: !Ref 'testVpc'
    Type: AWS::EC2::Subnet
```

As you can see from the previous template, the main difference between the two subnets is the ```MapPublicIpOnLaunch``` parameter.

By default, the instances created in subnets will **not** have internet access. In order to give the instances access to the internet, we will need to use **gateways** - an [Internet Gateway](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ec2-internetgateway.html) for the public subnet, and a [NAT Gateway](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ec2-natgateway.html) for the private subnet. These are separate instances, whose only purpose is forwarding the traffic to the internet. The reason we use different types of instances depending on the type of subnet we deploy to is that private instances do not have a public IP, so we need to perform network address translation on them. This is not the case with public instances, whose traffic can just be routed to an Internet Gateway, without needing a NAT.

In order to use these gateways, we need [routes](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ec2-route.html) in [route tables](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ec2-routetable.html), which will associate them to subnets. An IGW will be associated with a public subnet, whereas a NGW will be associated with a private subnet (but will be created in a public subnet, so it can do the routing). Since the NGW will need to route to the internet from the public subnet, an IGW will also be required.

```
testIgw:
  Properties:
    Tags:
      - Key: Name
        Value: Internet Gateway
  Type: AWS::EC2::InternetGateway
# this will need to be tied to a public subnet
testNgw:
  Properties:
    AllocationId: <EIP-ALLOCATION-ID>
    SubnetId: !Ref 'publicSubnet'
    Tags:
      - Key: Name
        Value: NAT Gateway
  Type: AWS::EC2::NatGateway
# this is created in a public subnet
```

An [EIP](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ec2-eip.html) (required for the NGW) is a public IP that will not change with instance restarts (once allocated, it remains the same). This is not true for public IPs configured in public subnets - restarting an instance there will change the public IP.
As previously mentioned, we will need to *explicitly* route traffic through these gateways, using a *Route*, a *RouteTable*, and a *SubnetRouteTableAssociation*:

```
testRouteTable:
  Properties:
    Tags:
      - Key: Name
        Value: Route Table
    VpcId: !Ref 'vpc'
  Type: AWS::EC2::RouteTable
testRoute:
  Properties:
    DestinationCidrBlock: '0.0.0.0/0' # in order to forward traffic to the internet, which is our destination
    NatGatewayId: !Ref 'ngw' # this will become GatewayId in the case of an IGW
    RouteTableId: !Ref 'testRouteTable'
  Type: AWS::EC2::Route
testAssociation:
  Properties:
    RouteTableId: !Ref 'testRouteTable'
    SubnetId: !Ref 'subnet'
  Type: AWS::EC2::SubnetRouteTableAssociation
```

Also adding on the public/private meanings from before, we can define the subnets as:
- Public subnet: a subnet associated with a route table that has a route associated to an Internet Gateway
- Private subnet: a subnet associated with a route table that has a route associated to a NAT Gateway

Routing to and from the internet does not necessarily mean that we want the traffic to go on *all* ports - this is why we should have security measures in place, the most basic of which is a *firewall*, known in AWS as a [Security Group](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ec2-security-group.html). A Security Group can have multiple ingress/egress (inbound/outbound) rules, on various ports, which basically whitelists connections there. Since SGs work on a whitelist basis, the traffic is blocked, by default.

```
InstanceSecurityGroup:
  Type: AWS::EC2::SecurityGroup
  Properties:
    GroupDescription: Allow http to client host
    VpcId:
        Ref: myVPC
    SecurityGroupIngress:
    - IpProtocol: tcp
      FromPort: 80
      ToPort: 80
      CidrIp: 0.0.0.0/0
    SecurityGroupEgress:
    - IpProtocol: tcp
      FromPort: 80
      ToPort: 80
      CidrIp: 0.0.0.0/0
```

The above security group will allow HTTP trafic in and out of the security group (which will later be placed on an instance or a subnet).
By default, there will be an *standard egress rule* in the SG, which allows outbound traffic on all ports - in order to overwrite this, you will need to specify at least one egress rule in the SG creation.
## EC2 Instances

[EC2 instances](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ec2-instance.html) are, simply put, virtual servers, with custom CPU and memory capacity. The only mandatory part of the instance is the *ImageId*, which is the ID of the AMI (Amazon Machine Image) that you want to create the instance with. The AMI generally refers to the software we want to have, as well as any particularities of that AMI (for example, a MySQL AMI might run on Linux, but it will also have a MySQL server installed by default). **AMIs are region-specific**, so the correct AMI ID must be chosen for the region we are working in (if we have a multi-region CFN template, for example, we can create a Map with region->AMI for ease of use).

Apart from that, we can customize the instance power via its [InstanceType](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/instance-types.html) - generally speaking, we have *compute-optimized, memory-optimized, storage-optimized and general-purpose* instance types. The usage of these instance types largely on the workflow that the specific instance will handle. Each instance type also has a few sizes to choose from, which will be again determined by the workflow. If left unspecified, it will default to ```m1.small```.
AWS has a naming convention for the instance types - based on ```m1.small```, **m** is the instance family, **1** is the generation (newer generations are generally better), and **small** is the instance size.

Additional parameters may be used in the instance creation (such as Security Group, VPC, Subnet, etc), depending on the network configuration that the application has.

```
Ec2Instance: 
  Type: AWS::EC2::Instance
  Properties: 
    ImageId: 
      Fn::FindInMap: 
        - "RegionMap" # this assumes that our CFN template has a RegionMap defined in a Mappings section
        - Ref: "AWS::Region"
        - "AMI"
    KeyName: !Ref 'MyKeyName'
    SubnetId: !Ref 'MySubnet'
    SecurityGroups:
      - !Ref 'MySG'
    InstanceType: 't3.nano'
```

If you are not sure what instance type to use, go with a general purpose one. [Memory-optimized](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/memory-optimized-instances.html) instances have optimized RAM to process large data sets in memory (for a DB, for example), [compute-optimized](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/compute-optimized-instances.html) are better suited for high-performance servers / computing, machine learning, or antything that requires a lot of computing power, and [storage-optimized](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/storage-optimized-instances.html) instances are useful for distributed file systems and workloads, which require low latency IOPS (I/O Operations per second).

Instances can also be configured via [UserData](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/user-data.html), which is a script that runs **only** on instance creation. In this script, you can specify various commands that configure your instance for the application purposes (installing certain packages, configuring some applications, etc).

## EC2 Billing and Spot Instances

EC2 instances are billed as you go (hourly, generally speaking). If the application is using large and powerful instances, or a lot of smaller instances, this can get costly fast. Most of the time, you will be using [on-demand](https://aws.amazon.com/ec2/pricing/on-demand/) instances, which are reliable, will almost never face disruptions, but are costly. AWS offers [spot](https://aws.amazon.com/ec2/spot/) instances as well, which are made from unused computing resources on the AWS servers. This means that they will be cheaper, but you might find out that your instances will be terminated (i.e. they are less reliable than on-demand instances). AWS also has [savings plans](https://aws.amazon.com/savingsplans/) (if you know that you will use the same capacity for 1/3 years), or [dedicated hosts](https://aws.amazon.com/ec2/dedicated-hosts/), which are servers dedicated to your applications (if you need this for compliance purposes, or if you have applications that must be configured with specific hardware identifiers).

Spot instances prices are always fluctuating. They are used by setting a maximum price that you are willing to pay, and if the price is under the treshold, the instance will be running. Once the price goes over the maximum price, the instance will be either terminated or stopped (which can be configured within the spot request). Spot instances are most useful when it comes to non-essential workflows, or batch jobs that can withstand termination (they should **not** be used for essential parts of the application).

## EC2 Storage Options

Whenever creating an EC2 Instance, we will also have to think about the storage, and the way we will be using the said storage. We have 4 main options here:
- [EC2 Instance Store](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/InstanceStorage.html): this is a hard disk physically attached to the host computer where the instance is run; this type of storage is ephemeral, so it will be lost on restart, which makes it useful for cache or temporary data
- [EBS](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AmazonEBS.html): AWS Elastic Block Store is a network-bound storage, which means that it can be attached/detached to/from any instance; this can live on after the instance is stopped/terminated, so it is recommended for data which shouldn't be lost. Generally speaking, an EBS volume will be attached to one instance only - however, additional configuration can be made via the [Multi-Attach](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ebs-volumes-multi.html) feature.
- [EFS](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AmazonEFS.html): AWS Elastic File System is a network-bound file system; unlike EBS, it is automatically scaled by AWS, and it can be attached to multiple instances at once, which makes it useful if the storage needs to be accessed by multiple applications
- [S3](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AmazonS3.html): AWS S3 is an AWS-managed data storage infrastructure; EC2 instances can push objects to S3 and further use them. This is useful if we also need these files to be accessible from the internet, without additional configuration - more on this in the S3 topic.

## EC2 AutoScaling

More often than not, we will have a couple of instances at our disposal for the application. If the demand for the application increases in certain periods, the instances we have might not be able to keep up with it. On the other hand, if the demand is too low and we have too many instances, they will be billed for doing almost no work, which is not cost-optimized. These two problems are solved via the [AutoScaling](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/AWS_AutoScaling.html) component.

In broad terms, we will have to define the min/max number of instances that we want, their type, and the desired capacity. We can also define specific metrics by which we can scale up (adding more instances) or scale down (removing unused instances), but these metrics will have to be related to **CloudWatch**.

```
myLaunchTemplate:
  Type: AWS::EC2::LaunchTemplate
  Properties: 
    LaunchTemplateName: !Sub ${AWS::StackName}-launch-template
    LaunchTemplateData: 
      BlockDeviceMappings: 
        - Ebs:
            VolumeSize: 22
            VolumeType: gp3
            DeleteOnTermination: true
            Encrypted: true
          DeviceName: /dev/xvdcz
      ImageId: ami-02354e95b39ca8dec
      InstanceType: t3.micro
      KeyName: my-key-pair-useast1
      Monitoring: 
        Enabled: true
      SecurityGroupIds: 
        - sg-7c227019
        - sg-903004f8
myASG:
  Type: AWS::AutoScaling::AutoScalingGroup
  Properties:
    AutoScalingGroupName: myASG
    MinSize: "1"
    MaxSize: "6"
    DesiredCapacity: "2"
    HealthCheckGracePeriod: 300
    LaunchTemplate:
      LaunchTemplateId: !Ref myLaunchTemplate
      Version: !GetAtt myLaunchTemplate.LatestVersionNumber
    VPCZoneIdentifier:
      - !Ref myPublicSubnet1
      - !Ref myPublicSubnet2
    MetricsCollection: 
      - Granularity: "1Minute"
        Metrics: 
          - "GroupMinSize"
          - "GroupMaxSize"
    Tags:
      - Key: Environment
        Value: Production
        PropagateAtLaunch: "true"
      - Key: Purpose
        Value: WebServerGroup
        PropagateAtLaunch: "false"
```

The [Launch Configuration](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-autoscaling-launchconfiguration.html) specifies how each instance should be configured, whereas the ASG specifies how the group should scale.

# Elastic Load Balancing (ELB)

Now that we have multiple instances (which will make our infrastructure more resilient, if they're multi-AZ, or optimized for the workload, if we have multiple instances per AZ - or a mix of both), the infrastructure needs to know how to route to these instances, and how to do so in an optimized manner. This is where the [Elastic Load Balancing](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/AWS_ElasticLoadBalancingV2.html) comes in.

AWS ELB is a service that helps us evenly distribute the application load across several applications (which can be either server or container based). Certain key concepts are shared across all the load balancers we have at our disposal (such as *Listeners*, which will listen to a certain path, and will be used during routing). The can also be used for health checks. We have multiple load balancer types to choose from:
- [Classic Load Balancer](https://docs.aws.amazon.com/elasticloadbalancing/latest/classic/introduction.html): this is the first LB created in the AWS ecosystem. It uses listeners to know the instances and ports it needs to send the TCP/HTTP/HTTPS traffic to.
- [Application Load Balancer](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/introduction.html): this is one of the *V2* load balancers. Aside from listeners, it uses the concept of [Target Groups](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-elasticloadbalancingv2-targetgroup.html), which the Listeners point towards. The main difference here is that you can have multiple target groups, which target different parts of the application. For example, you can have a listener with a rule for /api/app1, which would point to a target group with the app1 servers, and a listener for /api/app2, which would point to a different target group, with a different codebase. This can also be used for container-based target groups, private IP address target groups, or lambda target groups, and it only forwards HTTP/HTTPS traffic.
- [Network Load Balancer](https://docs.aws.amazon.com/elasticloadbalancing/latest/network/): similar to the ALB, but it forwards TCP/UDP traffic. This has less latency than the ALB, and it is mostly used when very good performance and request throughput is needed.
- [Gateway Load Balancer](https://docs.aws.amazon.com/elasticloadbalancing/latest/gateway/): this is the newest type of LB. It is similar to an ALB, but its purpose is to delegate requests to other applications before they forward the requests to the app servers - for example, when a request hits, you can forward it to a security application (that will check the payload, etc), and if everything is ok, forward it to the application server *afterwards*.

To create a CLB, use [this reference](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ec2-elb.html). For ALB/NLB/GWLB, use [this reference](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-elasticloadbalancingv2-loadbalancer.html).

# Relational Database Service (RDS)

Generally speaking, we can create standalone databases using EC2 instances - however, this will imply maintenance work on them. The Amazon [Relational Database Service](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/AWS_RDS.html) is managed DB service, in which you can create database instances that the applications can connect to, without worrying about the management aspect. The central component here is a [DBInstance](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-rds-database-instance.html). You can also use specific [DBSecurityGroups](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-rds-security-group.html) to restrict traffic to the database instance.

To configure a DBInstance, you will have to specify an InstanceClass (similar to EC2 instance types), some db-related configurations (master username/password), and a DB Engine. The engine will be the RDBMS (Relational Database Management System) used - mySQL, postgres, mariadb, etc.

```
MyDB:
  Type: 'AWS::RDS::DBInstance'
  Properties:
    DBInstanceIdentifier: 'my-db-aws-identifier'
    DBName: 'my-application-db'
    DBInstanceClass: db.m4.large
    AllocatedStorage: 50
    Engine: MySQL
    EngineVersion: 8.0.16
    MasterUsername: 'username'
    MasterUserPassword: 'very-secure-password'
    MonitoringInterval: '60'
    MonitoringRoleArn: 'role-arn' # for sending metrics to CloudWatch
```

# Elastic Container Service (ECS)
ECS: task definition, services, scheduling, clusters, container agent
Amazon [Elastic Container Service](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/AWS_ECS.html) builds upon EC2, but bringin container functionality to the instances, without the management usually associated with Docker running on standalone instances (since ECS is a managed services). 

The biggest logical components of ECS are [Task Definitions](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ecs-taskdefinition.html) (which define the way the containers - tasks - should be brought up), and [Services](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ecs-service.html) (which define how the tasks should run, and the number of tasks we should have running at the same time). This can be further organized in [Clusters](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ecs-cluster.html).

```
cluster:
    Type: AWS::ECS::Cluster
taskdefinition:
  Type: AWS::ECS::TaskDefinition
  Properties:
    ContainerDefinitions:
      - Name: !Ref AppName
        MountPoints:
          - SourceVolume: my-vol
            ContainerPath: /var/www/my-vol
        Image: amazon/amazon-ecs-sample
        Cpu: '10'
        PortMappings:
          - ContainerPort: !Ref AppContainerPort
            HostPort: !Ref AppHostPort
        EntryPoint:
          - /usr/sbin/apache2
          - '-D'
          - FOREGROUND
        Memory: '500'
        Essential: true
      - Name: busybox
        Image: busybox
        Cpu: '10'
        EntryPoint:
          - sh
          - '-c'
        Memory: '500'
        Command:
          - >-
            /bin/sh -c "while true; do /bin/date > /var/www/my-vol/date; sleep
            1; done"
        Essential: false
        VolumesFrom:
          - SourceContainer: !Ref AppName
    Volumes:
      - Host:
          SourcePath: /var/lib/docker/vfs/dir/
        Name: my-vol
service:
  Type: AWS::ECS::Service
  Properties:
    Cluster: !Ref cluster
    DesiredCount: 2
    HealthCheckGracePeriodSeconds: !Ref HealthCheckGracePeriodSeconds
    LoadBalancers:
      - ContainerName: !Ref AppName
        ContainerPort: !Ref AppContainerPort
        LoadBalancerName: !Ref elb
    PlacementStrategies:
      - Type: binpack
        Field: memory
      - Type: spread
        Field: host
    PlacementConstraints:
      - Type: memberOf
        Expression: 'attribute:ecs.availability-zone != us-east-1d'
      - Type: distinctInstance
    TaskDefinition: !Ref taskdefinition
    ServiceName: !Ref ServiceName
    Role: !Ref Role
Role:
  Type: AWS::IAM::Role
  Properties:
    AssumeRolePolicyDocument:
      Version: 2008-10-17
      Statement:
        - Sid: ''
          Effect: Allow
          Principal:
            Service: ecs.amazonaws.com
          Action: 'sts:AssumeRole'
    ManagedPolicyArns:
      - 'arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole'
```

In the previous example, a task definition with two container definition was created. Afterwards, a service was created in the cluster, specifying a DesiredCount of 2 tasks. You can also associate an ELB to the service, and you will need to specify a role that the ECS container instance will use in creating the tasks in the cluster it is registered to. If this is not properly configured, then you will not be able to create containers - more info [here](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/instance_IAM_role.html). You will also need to have the [ECS container agent](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ECS_agent.html) on the instances that you want to create the containers in (if you are not using an ECS-optimized AMI; if using an AWS ECS-optimized AMI, this will be included by default).

You can also use the [Elastic Container Repository](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/AWS_ECR.html) in conjunction with ECS. ECR is a repository for Docker images, which can be later referenced in ECS tasks.

# Simple Cloud Storage (S3)

Amazon [Simple Cloud Storage](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/AWS_S3.html) is a managed service that allows the creation of objects in the cloud. These objects can be anything - S3 will automatically scale to meet the needs of the objects being persisted. This storage is billed according to how much you use it.

Objects are organized in [Buckets](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-s3-bucket.html), and they can be pushed towards S3 Buckets via the API, CLI or console (which makes it very versatile). Objects can also have versions, if the bucket has [versioning](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-s3-bucket-versioningconfiguration.html) enabled.

In S3, file names are called keys, whereas folders are called prefixes - for example, backup/friday/v1.backup would have the ```backup/friday``` prefix, and the key would be ```v1.backup```. This is later used in retrieving objects.

S3 has multiple [Storage Classes](https://aws.amazon.com/s3/storage-classes/) which are strictly tied to how the objects are accessed. Separated in 3 general classes, they would be:
- Standard: this storage class would be used when objects need to be frequently accessed, and the retrieval times need to be very short. This is the most costly storage class.
- Infrequent Access: pertains to objects that are not accessed as frequently, but whose time of retrieval needs to be short. This is cheaper than the standard access
- Glacier: used for data that is rarely accessed. This is the cheapest option (the Deep Archive part costs very little), but the retrieval times are bigger than those of infrequent access storage (depending on the class, it might take up to 12 hours to be fetched).

We can also set [object lifecycle](https://docs.aws.amazon.com/AmazonS3/latest/userguide/object-lifecycle-mgmt.html) configurations for the buckets - these are very useful when we want to automatically move objects to a cheaper storage class after a certain time. For example, we might need application logs for quick retrieval within the first 30 days of putting them on S3, but after that they can be downgraded to IA, and then to Glacier, or deleted altogether.
# Other Services

Since the AWS ecosystem encompasses a wide array of tools and application needs, we did not cover all of their services in this documentation (as they are more targeted towards specific workloads). This section briefly describes some useful services:
- [Route53](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/AWS_Route53.html): this is the DNS offering in the AWS ecosystem, allowing us to create domain names for our applications, which will be used together with ELB
- [Elastic Kubernetes Service](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/AWS_EKS.html): this is a managed configuration for use with Kubernetes-based applications
- [Elastic Beanstalk](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/AWS_ElasticBeanstalk.html): this is a managed service used to automatically create infrastructure for existing applications, without needing to learn the aspects behind it (AWS PaaS offering)
- [Key Management Service](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/AWS_KMS.html): this is used for the management of keys; they can easily be referenced from within the AWS ecosystem
- [CloudWatch](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/AWS_CloudWatch.html): this service is used for creating alarms in conjunction with various metrics from the services. CloudWatch can be integrated with most AWS services - the metrics can be sent to various third-party apps (Grafana, for example), and they can also be used within AWS offerings (Autoscaling based on metrics for EC2 instances, etc).
- [Machine Learning](https://aws.amazon.com/machine-learning/): AWS has multiple Machine Learning offerings, which can be used in varied usecases
- [Lambda](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/AWS_Lambda.html): this AWS offering refers to code that does not necessarily need to run on a dedicated server. Lambdas behave more like functions, which return a certain output when they are called. This offering is billed by the number of calls, and how long the calls will be running for.
- [DynamoDB](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/AWS_DynamoDB.html): this is an AWS managed NoSQL database system, which scales automatically

