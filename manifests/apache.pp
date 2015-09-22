# Apache related setup for zoneminder
class zoneminder::apache {

  file{'/etc/apache2/conf-enabled/zoneminder.conf':
    ensure  => link,
    target  => '/etc/zm/apache.conf',
  } ~> Service['apache2']

  exec{'a2enmod cgi':
    user    => 'root',
    path    => ['/bin','/usr/sbin/','/usr/bin/'],
  } ~> Service['apache2']

  user{'www-data':
    ensure => present,
    groups => ['video'],
  } ~> Service['apache2']

  service{'apache2':
    ensure    => running,
    enable    => true,
    hasstatus => true,
  }
}
