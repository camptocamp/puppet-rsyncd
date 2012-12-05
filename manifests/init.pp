class rsyncd {

  realize(Package['rsync'])

  include rsyncd::params

  file { '/etc/rsyncd.conf':
    ensure => present,
  }

  augeas { 'set rsyncd pidfile':
    incl    => '/etc/rsyncd.conf',
    lens    => 'Rsyncd.lns',
    changes => "set '.anon/pid\\ file' /var/run/rsyncd.pid",
    require => File['/etc/rsyncd.conf'],
  }

  case $::osfamily {

    Debian: {
      augeas { 'enable rsync service':
        changes => 'set RSYNC_ENABLE true',
        lens    => 'Shellvars.lns',
        incl    => '/etc/default/rsync',
        notify  => Service['rsync'],
        require => Package['rsync'],
      }
      service { 'rsync':
        ensure     => running,
        enable     => true,
        hasstatus  => true,
        hasrestart => true,
        require    => Package['rsync'],
      }
    }

    RedHat: {

      $prefix = $rsyncd::params::xinetdcontext

      augeas { 'enable rsync service':
        incl    => '/etc/xinetd.d/rsync',
        lens    => 'Xinetd.lns',
        changes => [
          "set ${prefix}/disable no",
          "set ${prefix}/socket_type stream",
          "set ${prefix}/wait no",
          "set ${prefix}/user root",
          "set ${prefix}/server /usr/bin/rsync",
          "set ${prefix}/server_args/value --daemon",
        ],
        notify  => Service['xinetd'],
        require => Package['xinetd'],
      }
    }

  }

}
