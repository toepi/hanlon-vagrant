class profile::images {

  include wget

  wget::fetch { 'download microkernel':
    source      => 'http://github.com/csc/Hanlon-Microkernel/releases/download/v1.0/hnl_mk_prod-image.1.0.iso',
    destination => '/vagrant/hnl_mk_prod-image.1.0.iso',
    verbose     => false,
  }

  exec { 'add mk':
    command => '/opt/hanlon/cli/hanlon image add -t mk -p /vagrant/hnl_mk_prod-image.1.0.iso',
  }

  anchor { 'profile::images::begin': }
  anchor { 'profile::images::end': }

  Anchor['profile::images::begin'] ->
  Class['wget'] ->
  Wget::Fetch['download microkernel'] ->
  Exec['add mk'] ->
  Anchor['profile::images::end']

}

