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

  anchor { 'profile::provision::begin':}
  anchor { 'profile::provision::end':}

  Anchor['profile::provision::begin'] ->
  Class['hanlon'] ->
  File['/opt/hanlon/web/log'] ->
  Anchor['profile::provision::end']

}

