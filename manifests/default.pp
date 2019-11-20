
$user = 'jjas' # TODO: Put in username here (externalise)
$keys = [
	"AAAAB3NzaC1yc2EAAAABJQAAAQEAoyfC3dqtZew0Pej5oTDr/NnyZcdHUIxrqZ/08ZoEFGqgiBXafns86uQCLbYc18uQJAyiwIlcjCUxTBwSdP12nrv+/x7/ik7Br1hI1V+I3lCfUCo618VJN2Dm4LcTmAI274IYAspynnk33XhIyvFNtUC0DFqkJgGCjxOp595YWpjjunFARdyE7+pzeftuZ4HusVW3CO5tbvIW56GFfFqVkT+aynvdImUb8JVZloVa+DGKwz3/mz6145bSjpwfVFIwmC7SL3lraOG7TJDKAhaAUlb8FYkSAwZfqjsAIn5zXfn6NWCxJqujOuE6r3LWvnrmtTebwWJQYQOazcijvD6oSw==",
	"AAAAB3NzaC1yc2EAAAABJQAAAQEAjYTcB9kS49OL4YHKcJDGXiB81IUDzkC8KU9OkGeXRoayks5Jl+78WIqfZeifhY1pImdoqy2R0H3TmT4VIlYPO9/Yt+dzaXve2ydurcTgIPC9qLHlNPWz26x6uNK07+ybSKoFK1W+F8yMwQv4u6o9CitnANtrbQplRuOTQRc6gNTcqICIZwYWsTFcFFe9aqGqXcYPLTgGDdmomqgZEwiOYa8dg9WTqC93O0u3mgoIPQkpTNXE/MN8F+ScSLhrSedgDlLDC1TipWBkAVP48fFxtfeHr2JsoENOA0h0MoQ+VzdkQK1Y/Eta6lLGiyBvyt0U1w2acIP0IE7115aq7odyww=="
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
