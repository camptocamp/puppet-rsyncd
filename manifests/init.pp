class rsyncd {

  realize(Package["rsync"])

  file { "/etc/rsyncd.conf":
    ensure => present,
  }

  augeas { "set rsyncd pidfile":
    context => "/files/etc/rsyncd.conf/.anon/",
    changes => "set 'pid\\ file' /var/run/rsyncd.pid",
    require => File["/etc/rsyncd.conf"],
  }

  case $operatingsystem {

    Debian: {
      augeas { "enable rsync service":
        changes => "set /files/etc/default/rsync/RSYNC_ENABLE true",
        notify => Service["rsync"],
        require => Package["rsync"],
      }
      service { "rsync":
        ensure => running,
        enable => true,
        require => Package["rsync"],
      }
    }

    RedHat: {
      augeas { "enable rsync service":
        context => "/files/etc/xinetd.d/rsync/rsync/",
        changes => [
          "set disable no",
          "set socket_type stream",
          "set wait no",
          "set user root",
          "set server /usr/bin/rsync",
          "set server_args/value --daemon",
        ],
        notify => Service["xinetd"],
        require => Package["xinetd"],
      }
    }

  }

}
