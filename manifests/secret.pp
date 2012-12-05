define rsyncd::secret($ensure='present', $file='/etc/rsyncd.secrets', $passwd) {

  $change = $ensure ? {
    'present' => "set ${name} '${passwd}'",
    'absent'  => "rm ${name}"
  }

  augeas { "rsyncd.secret entry for ${name}":
    lens    => 'Htpasswd.lns',
    incl    => $file,
    changes => $change,
  }
}
