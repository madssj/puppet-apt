# == Class: apt::clean
#
# Create a cronjob which will run "apt-get clean" once a month.
#
# === Variables
#
#  *$apt_clean_minutes*: cronjob minutes  - default uses fqdn_rand(), range 0 to 59
#  *$apt_clean_hours*:   cronjob hours    - default to 0
#  *$apt_clean_mday*:    cronjob monthday - default uses fqdn_rand(), range 1 to 29
#
class apt::clean {
  $minutes  = $apt_clean_minutes? {'' => fqdn_rand(60), default => $apt_clean_minutes }
  $hours    = $apt_clean_hours?   {'' => '0'          , default => $apt_clean_hours }
  $monthday = $apt_clean_mday?    {'' => fqdn_rand(28) + 1, default => $apt_clean_mday }

  cron {'cleanup APT cache - prevents diskfull':
    ensure   => present,
    command  => 'apt-get clean',
    hour     => $hours,
    minute   => $minutes,
    monthday => $monthday,
  }
}
