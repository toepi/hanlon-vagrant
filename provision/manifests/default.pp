$db_user = "hanlon"
$db_name = "project_hanlon"
$db_pwd  = "test1234"

class { 'profile::database':
  db_name    => $db_name,
  role_name  => $db_user,
  role_pwd   => $db_pwd,
}

class { 'profile::provision':
  db_user    => $db_user,
  db_pwd     => $db_pwd,
  listenaddr => '192.168.66.254',
}

class { 'profile::rackapp': }
class { 'profile::bootserver': }
class { 'profile::dhcpserver': }

anchor { 'default::hanlon::begin':}
anchor { 'default::hanlon::end': }

Anchor['default::hanlon::begin'] ->
Class['profile::database'] ->
Class['profile::rackapp'] ->
Class['profile::provision'] ->
Class['profile::bootserver'] ->
Class['profile::dhcpserver'] ->
Anchor['default::hanlon::end']

