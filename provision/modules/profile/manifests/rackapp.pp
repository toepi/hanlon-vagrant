class profile::rackapp {

  class { 'nginx':
    package_source     => 'passenger',
    http_cfg_append    => {
      'passenger_root' => '/usr/lib/ruby/vendor_ruby/phusion_passenger/locations.ini',
      'passenger_default_user'  => 'root',
      'passenger_default_group' => 'root',
    },
  }

  nginx::resource::vhost{ 'hanlon':
    ensure                => present,
    server_name           => [ $::fqdn, $::hostname ],
    listen_port           => 8026,
    ssl                   => false,
    www_root              => '/opt/hanlon/web/public',
    use_default_location  => false,
    access_log            => '/var/log/nginx/hanlon_access.log',
    error_log             => '/var/log/nginx/hanlon_error.log',
    vhost_cfg_append      => {
      'passenger_enabled' => 'on',
      'passenger_ruby'    => '/usr/bin/ruby',
      'passenger_user'    => 'root',
    },
  }

  anchor { 'profile::rackapp::begin': }
  anchor { 'profile::rackapp::end': }

  Anchor['profile::rackapp::begin'] ->
  Nginx::Resource::Vhost['hanlon'] ->
  Anchor['profile::rackapp::end']

}

