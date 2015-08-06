# Class: mcollective::server
#
# This class manages the mcollective package installation
#
# Requires:
#
class mcollective::server::package ( 
  $ensure = $mcollective::params::package_server_ensure 
  ) inherits mcollective::params{

  # validate parameters
  if !is_string($mcollective::params::package_server) and !is_array($mcollective::params::package_server) {
    fail('mcollective::params::package_server must be a string or an array of packages to install')
  }

  # install necessary package(s)
  package { $mcollective::params::package_server:
    ensure => $ensure,
  }

}
