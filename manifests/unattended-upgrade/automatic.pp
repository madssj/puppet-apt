class apt::unattended-upgrade::automatic inherits apt::unattended-upgrade {

  apt::conf{'99unattended-upgrade':
    ensure  => present,
    content => "APT::Periodic::Unattended-Upgrade \"1\";\n",
  }

  # in debian > wheezy, the unattended-upgrades checks o= and a=
  # in debian < wheezy, it only matches on archivename
  if $::operatingsystem == 'Debian' {
    if $::operatingsystemmajrelease >= 7 {
      $origins = [
        '${distro_id} ${distro_codename}',
        '${distro_id} ${distro_codename}-security',
        '${distro_id} ${distro_codename}-updates',
      ]
    } elsif $::operatingsystemmajrelease == 6 {
      $origins = [
        'Debian oldstable',
        'Debian oldstable-security',
      ]
    } else {
      fail('Unattended-upgrades not supported by target Debian version')
    }
  }

  apt::conf{'50unattended-upgrades':
    ensure  => present,
    content => template("apt/unattended-upgrades.${::lsbdistid}.erb"),
  }

}
