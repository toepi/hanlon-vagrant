class profile::provision(
  $db_user    = undef,
  $db_pwd     = undef,
  $listenaddr = undef,
){

  class { 'hanlon':
    source_rev => 'master',
    listenaddr => $listenaddr,
    dbtype     => 'postgres',
    dbuser     => $db_user,
    dbpwd      => $db_pwd,
    dbport     => '5432',
  }

  file { '/var/log/hanlon':
    ensure => directory,
  }

  file { '/opt/hanlon/web/log':
    ensure  => link,
    target  => '/var/log/hanlon',
    require => File['/var/log/hanlon'],
  }

  include wget

  wget::fetch { 'download microkernel':
    source      => 'http://github.com/csc/Hanlon-Microkernel/releases/download/v1.0/hnl_mk_prod-image.1.0.iso',
    destination => '/vagrant/hnl_mk_prod-image.1.0.iso',
    verbose     => false,
  }

  exec { 'add mk':
    command => '/opt/hanlon/cli/hanlon image add -t mk -p /vagrant/hnl_mk_prod-image.1.0.iso',
  }

  anchor { 'profile::provision::begin':}
  anchor { 'profile::provision::end':}

  Anchor['profile::provision::begin'] ->
  Class['hanlon'] ->
  File['/opt/hanlon/web/log'] ->
  Class['wget'] ->
  Wget::Fetch['download microkernel'] ->
  Exec['add mk'] ->
  Anchor['profile::provision::end']

}

