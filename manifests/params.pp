class rsyncd::params {

  $xinetdcontext = $operatingsystem ? {
    'RedHat' => $lsbmajdistrelease ? {
      6 =>  $lsbdistrelease ? {
        /6\.0|6\.1/ => '/files/etc/xinetd.d/rsync/rsync/',
        default   => '/files/etc/xinetd.d/rsync/service/',
      },
      default => '/files/etc/xinetd.d/rsync/rsync/',
    },
    'Debian' => '',
  }

}
