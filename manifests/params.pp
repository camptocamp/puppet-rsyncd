class rsyncd::params {

  if versioncmp($::augeasversion, '0.7.3') < 0 {
    $xinetdcontext = 'rsync/'
  } else {
    $xinetdcontext = 'service[.="rsync"]'
  }

}
