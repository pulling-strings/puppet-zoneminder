# Setting up zoneminder based on: # http://bit.ly/1LMc7W8
class zoneminder {

  include apt

  apt::ppa {'ppa:iconnor/zoneminder':
    package_manage => true
  }

  $set_selction = '/usr/bin/debconf-set-selections'
  $mysql = 'mysql-server-5.6'
  $set_as = 'password root'

  exec{'set-mysql-password':
    command => "/bin/echo '${mysql} mysql-server/root_password ${set_as}' | ${set_selction}",
    user    => 'root',
    path    => ['/usr/bin','/bin',]
  } ->

  exec{'set-mysql-password-again':
    command => "/bin/echo '${mysql} mysql-server/root_password_again ${set_as}'| ${set_selction}",
    user    => 'root',
    path    => ['/usr/bin','/bin',]
  }

  package{'zoneminder':
    ensure  => present,
    require => [Apt::Ppa['ppa:iconnor/zoneminder'],
                Exec['set-mysql-password-again']]
  }


  package{['libvlc-dev', 'libvlccore-dev', 'vlc' ]:
    ensure  => present
  }

  file { '/etc/tmpfiles.d/zoneminder.conf':
    ensure  => file,
    mode    => '0755',
    content => 'd /var/run/zm 0755 www-data www-data',
    owner   => root,
    group   => root,
    require => Package['zoneminder']
  } ->

  service{'zoneminder':
    ensure    => running,
    enable    => true,
    hasstatus => true,
    provider  => 'systemd'
  }

  class{'zoneminder::apache':
    require => Package['zoneminder']
  }
}
