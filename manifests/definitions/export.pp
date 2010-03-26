define rsyncd::export ($ensure=present, $chroot=true, $readonly=true, $path=undef, $uid=undef, $gid=undef, $users=undef, $secrets=undef, $allow=undef, $deny=undef) {

  $ctx = "/files/etc/rsyncd.conf"

  case $ensure {
    present: {

      if $path {
        augeas { "setup rsyncd export $name":
          changes => [
            "set '$ctx/$name/#comment' 'created by rsyncd::export($name)'",
            "set '$ctx/$name/path' '$path'",
            "set '$ctx/$name/use\\ chroot' $chroot",
            "set '$ctx/$name/read\\ only' $readonly",
          ],
          require => Augeas["set rsyncd pidfile"],
        }

        if $uid {
          augeas { "set rsyncd uid for $name":
            changes => "set '$ctx/$name/uid' $uid",
            require => Augeas["setup rsyncd export $name"],
          }
        }

        if $gid {
          augeas { "set rsyncd gid for $name":
            changes => "set '$ctx/$name/gid' $gid",
            require => Augeas["setup rsyncd export $name"],
          }
        }

        if $users {
          augeas { "set rsyncd auth users for $name":
            changes => "set '$ctx/$name/auth\\ users' '$users'",
            require => Augeas["setup rsyncd export $name"],
          }
        }

        if $secrets {
          augeas { "set rsyncd secrets file for $name":
            changes => "set '$ctx/$name/secrets\\ file' '$secrets'",
            require => Augeas["setup rsyncd export $name"],
          }
        }

        if $allow {
          augeas { "set rsyncd hosts allow for $name":
            changes => "set '$ctx/$name/hosts\\ allow' '$allow'",
            require => Augeas["setup rsyncd export $name"],
          }
        }

        if $deny {
          augeas { "set rsyncd hosts deny for $name":
            changes => "set '$ctx/$name/hosts\\ deny' '$deny'",
            require => Augeas["setup rsyncd export $name"],
          }
        }

      }
      else {
        fail("missing mandatory \$path parameter for rsyncd::export($path).")
      }

    }
    absent: {
      augeas { "remove $name":
        changes => "remove '$ctx/$name'",
      }
    }
  }
}
