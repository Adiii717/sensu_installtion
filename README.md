# Sensu Installation with Dependency

Install Sensu on your AWS EC2 linux 2 based instance
Remember AWS EC2 Linux Version 1 don't support `systemd` so we will not be able to start services on version 1

## To Check Version
```
[ec2-user@ip-172-30-0-61 ~]$ cat /etc/os-release
NAME="Amazon Linux AMI"
VERSION="2018.03"
ID="amzn"
ID_LIKE="rhel fedora"
VERSION_ID="2018.03"
PRETTY_NAME="Amazon Linux AMI 2018.03"
ANSI_COLOR="0;33"
CPE_NAME="cpe:/o:amazon:linux:2018.03:ga"
HOME_URL="http://aws.amazon.com/amazon-linux-ami/"

[ec2-user@ip-172-30-0-61 ~]$ sudo systemd
sudo: systemd: command not found  
```

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

### Prerequisites

Does not need any prerequisites as it will install redis, rabbitmq and sensu plus uchiwa :)

```

```

### Installing
```
chmod +x install.sh
```
then

```
./install.sh
```

And check everything install well.

```
until finished
```



## Contributing

Please read [CONTRIBUTING.md](https://gist.github.com/PurpleBooth/b24679402957c63ec426) for details on our code of conduct, and the process for submitting pull requests to us.

## Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://github.com/your/project/tags). 

## Authors

* **Adil Mehmood** - *Initial work* - [ThinkDifferent](https://github.com/Adiii717)

See also the list of [contributors](https://github.com/Adiii717/sensu_installtion/graphs/contributors) who participated in this project.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments



