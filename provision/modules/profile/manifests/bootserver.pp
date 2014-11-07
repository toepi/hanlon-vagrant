class profile::bootserver {

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

    anchor { 'profile::bootserver::begin':}
    anchor { 'profile::bootserver::end': }

    Anchor['profile::bootserver::begin'] ->
    Class['tftp'] ->
    Tftp::File<||> ->
    Anchor['profile::bootserver::end']

}

