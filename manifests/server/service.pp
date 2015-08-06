# Class: mcollective::server::service
#
# This class manages the mcollective package installation
#
# Requires:
#
class mcollective::server::service ( 
  $ensure = $mcollective::params::service_ensure,
  $enable = $mcollective::params::service_enable
  ) inherits mcollective::params{

  # manage the mcollective server service
  service { 'mcollective-server':
    ensure     => $ensure,
    name       => $mcollective::params::service_name,
    enable     => $enable,
    hasrestart => $mcollective::params::service_hasrestart;
  }

}
