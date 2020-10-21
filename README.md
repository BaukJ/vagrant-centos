# Vagrant Centos Image

## Getting started

To start the instance, edit manifests/default.pp to add in your UID and your ssh keys.
Then run, from the root folder:

`vagrant up`

You should not be able to use `vagrant ssh` to login as the vagrant user, or just ssh to the instance. It has an extra IP of 192.168.222.222 which you can use to ssh and to access all other ports (e.g. for hosting websites).

### Help getting setup
You need to ensure you have the vagrant-vbguest plugin so that mounts will work with virtualbox.
Install it with the following command:

`vagrant plugin install vagrant-vbguest`



