class profile::dhcpserver {

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

    anchor { 'profile::dhcpserver::begin':}
    anchor { 'profile::dhcpserver::end': }

    Anchor['profile::dhcpserver::begin'] ->
    Dhcp::Pool['localdomain'] ->
    Anchor['profile::dhcpserver::end']

}

