class rsyncd::params {

  $xinetdcontext = $::osfamily ? {
    'RedHat' => $::lsbmajdistrelease ? {
      6 =>  $::lsbdistrelease ? {
        /6\.0|6\.1/ => 'rsync/',
        default   => 'service/',
      },
      default => 'rsync/',
    },
    'Debian' => '',
    'Ubuntu' => '',
  }

}
