# Class: mcollective::server::config
#
# This class manages the configuration of a mcollective server
#
# Requires: concat
#
class mcollective::server::config (
  $server,
  $user,
  $password,
  $rpcauth_provider,
  ) inherits mcollective::params{


  concat { "${mcollective::params::config_path}/server.cfg":
    ensure => 'present',
    notify => Service [ 'mcollective-server' ];
  }

  # server.cfg configuration fragment
  concat::fragment { 'server-cfg':
    target  => "${mcollective::params::config_path}/server.cfg",
    content => template('mcollective/server.cfg.erb'),
    order   => '01',
  }

  File {
    owner   => 'root',
    group   => 'root',
    mode    => '0640',
    require => Package [ $mcollective::params::package_server ],
    notify  => Service [ 'mcollective-server' ],
  }

  # push out server SSL certificates and all client SSL certificates
  file {
    "${mcollective::params::config_path}/ssl/server_public.pem":
    source  => 'puppet:///modules/mcollective/server_public.pem';

    "${mcollective::params::config_path}/ssl/server_private.pem":
    mode    => '0600',
    source  => 'puppet:///modules/mcollective/server_private.pem';

    "${mcollective::params::config_path}/ssl/clients":
    recurse => true,
    purge   => true,
    source  => 'puppet:///modules/mcollective/clients';

    "${mcollective::params::config_path}/policies":
    ensure => 'directory';
  }

  # file resource for facts.yaml
  file {
    "${mcollective::params::config_path}/facts.yaml":
    mode     => '0400',
    loglevel => debug,   # this is needed to avoid it being logged and reported every run
    backup   => false,
    content  => template('mcollective/facts.yaml.erb');
  }


}
