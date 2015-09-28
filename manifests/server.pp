# Class: mcollective::server
#
# This class manages a mcollective server (package, service and config)
#
# Requires:
#
class mcollective::server (
  $service_enable = $mcollective::params::service_enable,
  $service_ensure = $mcollective::params::service_ensure,
  $package_ensure = $mcollective::params::package_server_ensure,
  $server,
  $user,
  $password,
  $rpcauth_provider,
  ) inherits mcollective::params {

  # call sub classes
  class {

    'mcollective::server::package':
    ensure    => $package_ensure;

    'mcollective::server::service':
    ensure    => $service_ensure,
    enable    => $service_enable;

    'mcollective::server::config':
    server           => $server,
    user             => $user,
    password         => $password,
    rpcauth_provider => $rpcauth_provider,

  }

}
