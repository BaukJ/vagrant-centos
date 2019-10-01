# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'getoptlong'

#opts = GetoptLong.new(
#  [ '--gui', GetoptLong::OPTIONAL_ARGUMENT ]
#)

gui = false

#opts.each do |opt, arg|
#  case opt
#    when '--gui' then gui = true
#  end
#end

Vagrant.configure("2") do |config|
  config.vm.box = "centos/7"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # NOTE: This will enable public access to the opened port
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine and only allow access
  # via 127.0.0.1 to disable public access
  # config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"

  # Create a private network, which allows host-only access to the machine using a specific IP.
  config.vm.network "private_network", ip: "192.168.222.222"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  config.vm.synced_folder "../share/linux", "/SHARE" #, type: "rsync" # Can change to smb for faster performance

  config.vm.provider "virtualbox" do |vb|
   # Display the VirtualBox GUI when booting the machine
    vb.gui = gui
   # Customize the amount of memory on the VM:
    vb.memory = "4096"
    vb.cpus = 2
    vb.customize ["modifyvm", :id, "--vram", "64"]
	# # # Forward on specific USBs
	
	# # This forwards on all, but only once booted
    vb.customize ["modifyvm", :id, "--usb", "on"]
    vb.customize ["modifyvm", :id, "--usbehci", "on"]
    vb.customize ["modifyvm", :id, "--usbxhci", "on"]
	# # Add datasur
	# vb.customize ['usbfilter', 'add', '0', '--target', :id, '--name', 'USB', '--vendorid', '0x2d9b', '--productid', '0x2d9b']
	
	# # TODO: This should just forward on the specified usb
	#vb.customize ['usbfilter', 'add', '1', '--target', :id, '--name', "USBFASTP",
	#	'--vendorid',  '0x13fe',
	#	'--productid', '0x3600']
	#vb.customize ['usbfilter', 'add', '2', '--target', :id, '--name', "USBMTDB",
	#	'--vendorid',  '0x2d9b',
	#	'--productid', '0x6108']
	#vb.customize ['usbfilter', 'add', '0', '--target', :id, '--name', "KVM",
	#	'--vendorid',  '0x0d3d',
	#	'--productid', '0x0040',
    #    '--active', 'no']
  end

  config.vm.provision "shell", inline: <<-SCRIPT
	rpm -Uvh http://yum.puppet.com/puppet5-release-el-7.noarch.rpm
	yum -y install puppet-agent
SCRIPT

  config.vm.provision "puppet"
end
