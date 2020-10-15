Rsyncd
======

[![Puppet Forge Version](http://img.shields.io/puppetforge/v/camptocamp/rsyncd.svg)](https://forge.puppetlabs.com/camptocamp/rsyncd)
[![Puppet Forge Downloads](http://img.shields.io/puppetforge/dt/camptocamp/rsyncd.svg)](https://forge.puppetlabs.com/camptocamp/rsyncd)
[![Build Status](https://img.shields.io/travis/camptocamp/puppet-rsyncd/master.svg)](https://travis-ci.org/camptocamp/puppet-rsyncd)
[![Gemnasium](https://img.shields.io/gemnasium/camptocamp/puppet-rsyncd.svg)](https://gemnasium.com/camptocamp/puppet-rsyncd)
[![By Camptocamp](https://img.shields.io/badge/by-camptocamp-fb7047.svg)](http://www.camptocamp.com)

Requirements
------------

 - augeas >= 0.4.0
 - puppet >= 0.24.7 (which includes native augeas type)
 - this file (at least while it's not part of puppet), which fixes issue #1835:
   http://github.com/bkearney/puppet/tree/e431fee6de4c45fb85225d5aaff412ea0763d06f/lib/puppet/provider/augeas/augeas.rb

Example usage
-------------

```puppet
package { ["rsync", "xinetd"]: ensure => present }
service { "xinetd": ensure => running }

include rsyncd
$password = generate("/usr/bin/pwgen", 8, 1)

file { "/backup-mysql":
  ensure => directory,
  mode => 0775,
  owner => "dba",
  group => "dba",
}

file { "/home/dba/rsyncd.secret":
  content => "backup:${password}",
  replace => no,
  mode => 0460,
  owner=> "root",
  group => "dba",
  require => User["dba"],
}

rsyncd::export { "backup":
  path => "/backup-mysql",
  chroot => true,
  readonly => true,
  uid => "dba",
  gid => "dba",
  users => "backup",
  secrets => "/home/dba/rsyncd.secret",
  allow => "192.168.0.0/24",
  require => [File["/backup-mysql"], File["/home/dba/rsyncd.secret"]],
  prexferexec => "/home/dba/bin/pre-exec.sh",
  postxferexec => "/home/dba/bin/post-exec.sh",
  incomingchmod => "go=-w,+X",
  logfile => '/var/log/rsyncd.test.log',
}
```
