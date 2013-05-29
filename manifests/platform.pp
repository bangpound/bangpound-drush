define drush::platform(
  $makefile,
  $owner = 'www-data',
  $group = 'www-data',
  $root = "/var/www/$title",
) {

  File {
    owner => $owner,
    group => $group,
  }

  file { $root:
    ensure => directory,
    require => Exec["chown $title platform"],
  }

  file { "$root/sites/sites.php":
    mode  => 644,
    source => "$root/sites/example.sites.php",
    ensure => present,
    require => Exec["chown $title platform"],
  }

  exec { "drush make $title":
    command => "/usr/bin/drush --yes make $makefile $root",
    timeout => 0,
    creates => $root,
    require => Class['drush'],
  }

  exec { "chown $title platform":
    command => "/bin/chown -R $owner:$group $root",
    require => Exec["drush make $title"],
  }
}
