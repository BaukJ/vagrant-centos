

$user = 'user' # TODO: Put in username here (externalise)
$keys = []

user { $user:
	ensure			=> present,
	managehome		=> true,
	purge_ssh_keys	=> true
}
$keys.each |$key| {
	ssh_authorized_key { "ABC":
		ensure			=> present,
		user 			=> $user,
		type			=> "ssh-rsa",
		key				=> $key
	}
}

package { 'docker': 
}
