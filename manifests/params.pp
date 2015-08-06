# Class: mcollective::params 
#
# This class provides default parameters for the mcollective module
#
# Requires:
#
class mcollective::params {

  # non-OS specific default parameters
  $package_server_ensure      = hiera('mcollective::server::package_ensure', 'present')
  $package_client_ensure      = hiera('mcollective::client::package_ensure', 'present')
  $service_ensure             = hiera('mcollective::server::service_ensure', 'running')
  $service_enable             = hiera('mcollective::server::service_enable', true)

  case $::osfamily {
    'RedHat': {
      $package_server         = hiera('mcollective::server::package', 'mcollective')
      $package_client         = hiera('mcollective::client::package', 'mcollective-client')
      $service_name           = hiera('mcollective::server::service_name', 'mcollective')
      $service_hasrestart     = hiera('mcollective::server::service_hasrestart', true)
      $config_path            = hiera('mcollective::config_path', '/etc/mcollective')
      $mc_libdir              = hiera('mcollective::mc_libdir', '/usr/libexec/mcollective')
      $puppet_vardir          = hiera('mcollective::puppet_vardir', '/var/lib/puppet')
    }

    default: {
      fail("${module_name} : unsupported OS family ${::osfamily}")
    }
  }

}
