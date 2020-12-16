define rsyncd::export (
  $ensure=present,
  $chroot=true,
  $readonly=true,
  $writeonly=false,
  $mungesymlinks=true,
  $path=undef,
  $uid=undef,
  $gid=undef,
  $users=undef,
  $secrets=undef,
  $allow=undef,
  $deny=undef,
  $prexferexec=undef,
  $postxferexec=undef,
  $refuse=undef,
  $maxconnections=undef,
  $lockfile=undef,
  $incomingchmod=undef,
  $logfile=undef,
) {

  $file = '/etc/rsyncd.conf'

  case $ensure {
    'present': {

      if $path {
        augeas { "setup rsyncd export ${name}":
          incl    => $file,
          lens    => 'Rsyncd.lns',
          changes => [
            "set '${name}/#comment' 'created by rsyncd::export(${name})'",
            "set '${name}/path' '${path}'",
            "set '${name}/use\\ chroot' ${chroot}",
            "set '${name}/read\\ only' ${readonly}",
            "set '${name}/write\\ only' ${writeonly}",
          ],
          require => Augeas['set rsyncd pidfile'],
        }

        if $::osfamily == 'RedHat' {
          case $::operatingsystemmajrelease {

            '4','5','6': { }

            default: {
              augeas { "setup rsyncd munge symlinks ${name}":
                incl    => $file,
                lens    => 'Rsyncd.lns',
                changes => "set '${name}/munge\\ symlinks' ${mungesymlinks}",
                require => Augeas["setup rsyncd export ${name}"],
              }
            }
          }
        }

        if $uid {
          augeas { "set rsyncd uid for ${name}":
            incl    => $file,
            lens    => 'Rsyncd.lns',
            changes => "set '${name}/uid' ${uid}",
            require => Augeas["setup rsyncd export ${name}"],
          }
        }

        if $gid {
          augeas { "set rsyncd gid for ${name}":
            incl    => $file,
            lens    => 'Rsyncd.lns',
            changes => "set '${name}/gid' ${gid}",
            require => Augeas["setup rsyncd export ${name}"],
          }
        }

        if $users {
          augeas { "set rsyncd auth users for ${name}":
            incl    => $file,
            lens    => 'Rsyncd.lns',
            changes => "set '${name}/auth\\ users' '${users}'",
            require => Augeas["setup rsyncd export ${name}"],
          }
        }

        if $secrets {
          augeas { "set rsyncd secrets file for ${name}":
            incl    => $file,
            lens    => 'Rsyncd.lns',
            changes => "set '${name}/secrets\\ file' '${secrets}'",
            require => Augeas["setup rsyncd export ${name}"],
          }
        }

        if $allow {
          augeas { "set rsyncd hosts allow for ${name}":
            incl    => $file,
            lens    => 'Rsyncd.lns',
            changes => "set '${name}/hosts\\ allow' '${allow}'",
            require => Augeas["setup rsyncd export ${name}"],
          }
        }

        if $deny {
          augeas { "set rsyncd hosts deny for ${name}":
            incl    => $file,
            lens    => 'Rsyncd.lns',
            changes => "set '${name}/hosts\\ deny' '${deny}'",
            require => Augeas["setup rsyncd export ${name}"],
          }
        }

        if $refuse {
          augeas { "set rsyncd refuse options for ${name}":
            incl    => $file,
            lens    => 'Rsyncd.lns',
            changes => "set '${name}/refuse\\ options' '${refuse}'",
            require => Augeas["setup rsyncd export ${name}"],
          }
        }

        if $prexferexec {
          augeas { "set pre-xfer exec for ${name}":
            incl    => $file,
            lens    => 'Rsyncd.lns',
            changes => "set '${name}/pre-xfer\\ exec' ${prexferexec}",
            require => Augeas["setup rsyncd export ${name}"],
          }
        }

        if $postxferexec {
          augeas { "set post-xfer exec for ${name}":
            incl    => $file,
            lens    => 'Rsyncd.lns',
            changes => "set '${name}/post-xfer\\ exec' ${postxferexec}",
            require => Augeas["setup rsyncd export ${name}"],
          }
        }

        if $maxconnections {
          augeas { "set max connections for ${name}":
            incl    => $file,
            lens    => 'Rsyncd.lns',
            changes => "set '${name}/max\\ connections' ${maxconnections}",
            require => Augeas["setup rsyncd export ${name}"],
         }
         
         if $incomingchmod {
          augeas { "set incoming chmod for ${name}":
            incl    => $file,
            lens    => 'Rsyncd.lns',
            changes => "set '${name}/incoming\\ chmod' ${incomingchmod}",
            require => Augeas["setup rsyncd export ${name}"],
          }
        }

        if $lockfile {
          augeas { "set lock file for ${name}":
            incl    => $file,
            lens    => 'Rsyncd.lns',
            changes => "set '${name}/lock\\ file' ${lockfile}",
            require => Augeas["setup rsyncd export ${name}"],
        }

        if $logfile {
          augeas { "set log file for ${name}":
            incl    => $file,
            lens    => 'Rsyncd.lns',
            changes => "set '${name}/log\\ file' '${logfile}'",
            require => Augeas["setup rsyncd export ${name}"],
          }
        }

      }
      else {
        fail("missing mandatory \$path parameter for rsyncd::export(${path}).")
      }

    }
    'absent': {
      augeas { "remove ${name}":
        incl    => $file,
        lens    => 'Rsyncd.lns',
        changes => "remove '${name}'",
      }
    }
    default: {
      fail "Unknown value for ensure: ${ensure}"
    }
  }
}
