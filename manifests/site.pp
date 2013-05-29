define drush::site(
  $platform,
  $db_url,
  $sites_subdir = $title,
  $profile = 'standard',
  $owner = 'www-data',
  $group = 'www-data',
) {

  $root = getparam(Drush::Platform[$platform], 'root')

  File {
    owner => $owner,
    group => $group,
  }

  file { "$root/sites/$sites_subdir":
    ensure => directory,
    require => Exec["chown $title site"],
  }

  exec { "drush site-install $profile:$sites_subdir":
    cwd => $root,
    command => "/usr/bin/drush --yes site-install $profile --db-url=$db_url --sites-subdir=$sites_subdir",
    creates => "$root/sites/$sites_subdir",
  }

  exec { "chown $title site":
    command => "/bin/chown -R $owner:$group $root/sites/$sites_subdir",
    require => Exec["drush site-install $profile:$sites_subdir"],
  }
}
