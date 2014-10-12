include ::postgresql::server

postgresql::server::config_entry { 'ssl':
  value => 'false',
}

postgresql::server::role { 'hanlon':
  password_hash => 'test1234',
}

postgresql::server::database { 'project_hanlon':
  owner => 'hanlon',
}

class { '::hanlon': 
  source_rev => 'master',
  listenaddr => '192.168.66.254',
  dbtype     => 'postgres',
  dbuser     => 'hanlon',
  dbpwd      => 'test1234',
  dbport     => '5432'
}

file { '/var/log/hanlon':
  ensure => directory,
}

file { '/opt/hanlon/web/log':
  ensure  => link,
  target  => '/var/log/hanlon',
  require => File['/var/log/hanlon'],
}

class { 'nginx':
  package_source     => 'passenger',
  http_cfg_append    => {
    'passenger_root'          => '/usr/lib/ruby/vendor_ruby/phusion_passenger/locations.ini',
    'passenger_default_user'  => 'root',
    'passenger_default_group' => 'root',
  },
}

nginx::resource::vhost{ 'hanlon':
  ensure      => present,
  server_name => [ $::fqdn, $::hostname ],
  listen_port => 8026,
  ssl         => false,
  www_root    => '/opt/hanlon/web/public',
  use_default_location => false,
  access_log           => '/var/log/nginx/hanlon_access.log',
  error_log            => '/var/log/nginx/hanlon_error.log',
  vhost_cfg_append     => {
    'passenger_enabled' => 'on',
    'passenger_ruby'    => '/usr/bin/ruby',
    'passenger_user'    => 'root',
  },
}

package{ 'ipxe':
  ensure => present,
}

class{ 'tftp' :
  address => '192.168.66.254',
  inetd   => false,
}

tftp::file{ 'ipxe.lkrn':
  source  => 'file:///boot/ipxe.lkrn',
  require => Package['ipxe'],
}

package{ 'syslinux-common':
  ensure => present,
}

tftp::file{ 'pxelinux.0':
  source  => 'file:///usr/lib/syslinux/pxelinux.0',
  require => Package['syslinux-common'],
}

tftp::file{ 'menu.c32':
  source  => 'file:///usr/lib/syslinux/menu.c32',
  require => Package['syslinux-common'],
}

tftp::file{ 'pxelinux.cfg':
  ensure => directory,
}

tftp::file{ 'pxelinux.cfg/default':
  source => 'file:///vagrant/default',
}

tftp::file{ 'hanlon.ipxe':
  source => 'file:///vagrant/hanlon.ipxe',
}

class { 'dhcp':
  dnsdomain   => [ 'localdomain' ],
  interfaces  => [ 'eth1' ], 
  nameservers => [ '192.168.66.254' ],
  ntpservers  => [ '192.168.66.254' ],
  pxeserver   => '192.168.66.254',
  pxefilename => 'pxelinux.0',
}

dhcp::pool { 'localdomain':
  network => '192.168.66.0',
  mask    => '255.255.255.0',
  range   => [ '192.168.66.100 192.168.66.199' ],
  gateway => '192.168.66.254',
}

include wget

wget::fetch{ 'download microkernel':
  source      => 'http://github.com/csc/Hanlon-Microkernel/releases/download/v1.0/hnl_mk_prod-image.1.0.iso',
  destination => '/vagrant/hnl_mk_prod-image.1.0.iso',
  verbose     => true,
}

exec{ 'add mk':
  command    => '/opt/hanlon/cli/hanlon image add -t mk -p /vagrant/hnl_mk_prod-image.1.0.iso',
}

anchor { 'default::hanlon::begin':}
anchor { 'default::hanlon::end': }

Anchor['default::hanlon::begin'] ->
Class['::postgresql::server'] ->
Postgresql::Server::Role['hanlon'] ->
Postgresql::Server::Database['project_hanlon'] ->
Class['tftp'] ->
Dhcp::Pool['localdomain'] ->
Class['::hanlon'] ->
File['/opt/hanlon/web/log'] ->
Nginx::Resource::Vhost['hanlon'] ->
Tftp::File<||> ->
Class['wget'] ->
Wget::Fetch['download microkernel'] ->
Exec['add mk'] ->
Anchor['default::hanlon::end']

