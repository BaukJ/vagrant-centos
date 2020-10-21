# Your username and publis sshe key goes in here.
# The public ssh key is without the ssh-rsa bit.

$user = 'user' # TODO: Put in username here (externalise)
# TODO: insert your ssh keys below, in the format: "ssh_key_here==",
$keys = [
]


$packages = ["https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm", "git", "wget", "vim", "htop", "yum-utils",
  "docker-ce", "docker-ce-cli", "containerd.io", "device-mapper-persistent-data", "lvm2",
  "perl-JSON", "perl-YAML", "perl-TermReadKey", "perl-CGI"]

exec { "add docker repo":
	path => "/usr/bin",
	command => "/usr/bin/yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo",
	unless => "test -f /etc/yum.repos.d/docker-ce.repo",
	before => [Package["docker-ce"], Package["docker-ce-cli"], Package["containerd.io"]],
	require => Package["yum-utils"]
} ->
group { "docker":
} ->
# The vagrant user grants sudo access
user { $user:
	ensure			=> present,
	managehome		=> true,
	gid 			=> "vagrant",
	groups 			=> ["docker"],
	#purge_ssh_keys	=> true
}

$keys.each |$key| {
	ssh_authorized_key { $key:
		ensure			=> present,
		user 			=> $user,
		type			=> "ssh-rsa",
		key				=> $key
	}
}

$packages.each |$package| {
	package { $package: 
	}
}

service { "docker":
	ensure  => running,
	enable  => true,
	require => Package["docker-ce"]
}


##### Disable selinux
file { "/etc/selinux/config":
	content => @(SCRIPT)
		# This file controls the state of SELinux on the system.
		# SELINUX= can take one of these three values:
		#     enforcing - SELinux security policy is enforced.
		#     permissive - SELinux prints warnings instead of enforcing.
		#     disabled - No SELinux policy is loaded.
		SELINUX=permissive
		# SELINUXTYPE= can take one of three values:
		#     targeted - Targeted processes are protected,
		#     minimum - Modification of targeted policy. Only selected processes are protected.
		#     mls - Multi Level Security protection.
		SELINUXTYPE=targeted
		| SCRIPT
}
