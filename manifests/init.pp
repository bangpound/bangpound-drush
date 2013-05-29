# == Class: drush
#
# Full description of class drush here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if it
#   has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should not be used in preference to class parameters  as of
#   Puppet 2.6.)
#
# === Examples
#
#  class { drush:
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ]
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2011 Your name here, unless otherwise noted.
#
class drush {

  Exec {
    require => Package['pear.drush.org/drush'],
  }

  # install drush, we use this method over the ubuntu package as that requires
  # a drush self-update that prompts for a version. This method uses drush's
  # official pear channel.
  package { 'pear.drush.org/drush':
    ensure => latest,
    provider => pear,
    require  => Package['php5-cli'],
  }

  exec { 'drush dl registry_rebuild':
    command => '/usr/bin/drush dl --destination=/root/.drush registry_rebuild',
    creates => '/root/.drush/registry_rebuild',
  }
}
