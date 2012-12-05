define rsyncd::secret($passwd, $ensure='present', $file='/etc/rsyncd.secrets') {

  validate_re($ensure, ['^present$', '^absent$'])
  validate_absolute_path($file)

  $change = $ensure ? {
    'present' => "set ${name} '${passwd}'",
    'absent'  => "rm ${name}",
  }

  augeas { "rsyncd.secret entry for ${name}":
    lens    => 'Htpasswd.lns',
    incl    => $file,
    changes => $change,
  }
}
