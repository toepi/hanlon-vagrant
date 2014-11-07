class profile::database(
  $db_name   = undef,
  $role_name = undef,
  $role_pwd  = undef
){

  include ::postgresql::server

  postgresql::server::config_entry { 'ssl':
    value => 'false',
  }

  postgresql::server::role{ "$role_name":
    password_hash => "$role_pwd",
  }

  postgresql::server::database{ "$db_name":
    owner => "$role_name",
  }

  anchor{ 'profile::database::begin': }
  anchor{ 'profile::database::end': }

  Anchor['profile::database::begin'] ->
  Postgresql::Server::Config_entry<||> ->
  Postgresql::Server::Role["$role_name"] ->
  Postgresql::Server::Database["$db_name"] ->
  Anchor['profile::database::end']

}

