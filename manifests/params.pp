class rsyncd::params {

  $xinetdcontext = $operatingsystem ? {
    'RedHat' => $lsbmajdistrelease ? {
      6 =>  $lsbdistrelease ? {
        /6\.0|6\.1/ => '/rsync/',
        default   => '/service/',
      },
      default => '/rsync/',
    },
    'Debian' => '',
  }

}
