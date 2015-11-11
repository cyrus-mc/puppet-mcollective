# == Define: mcollective::plugin
#
# This define manages a mcollective plugin, addon
#
# Requires: concat
#
define mcollective::plugin (
  $ensure,
  $type,
  $package = true
  ) {

  include ::mcollective::params

  if $type == 'client' {
    # client plugins require the node to be configured as a client (this test should ensure
    # that mcollective::client is in catalog
    if ! defined(Class['mcollective::client']) {
      fail("You must declare mcollective::client class before you can use mcollective::plugin with type \'${type}\'")
    }

    # allow for possiblity that plugin has plugin specific config
    concat::fragment { "client_cfg-${name}":
      target  => "${mcollective::params::config_path}/client.cfg",
      content => template("mcollective/${name}-client.cfg.erb"),
    }
  } else {
    # if type is not client, it is server side configuration (assumption) (this test should ensure
    # that mcollective::server is in catalog
    if ! defined(Class['mcollective::server']) {
      fail("You must declare mcollective::server class before you can use mcollective::plugin with type \'${type}\'")
    }

    # allow for possibility that plugin has plugin specific config
    concat::fragment { "server_cfg-${name}":
      target => "${mcollective::params::config_path}/server.cfg",
      content => template("mcollective/${name}-server.cfg.erb"),
      notify  => Service[ $mcollective::params::service_name ];
    }
  }

  $_plugin_package = $type ? {
    'agent'  => "mcollective-${name}-${type}",
    'client' => "mcollective-${name}-${type}",
    default  => "mcollective-${name}",
  }

  $_service_notify = $type ? {
    'client' => undef,
    default  => Service[ $mcollective::params::service_name ],
  }

  if $package {
    # install necessary plugin package
    package { $_plugin_package:
      ensure => $ensure,
      notify => $_service_notify,
    }
  } else {
    file {
      "/usr/libexec/mcollective/mcollective/${type}/${name}.rb":
      source => "puppet:///modules/mcollective/plugins/${type}/${name}.rb",
      notify => $_service_notify;

      "/usr/libexec/mcollective/mcollective/${type}/${name}.ddl":
      source => "puppet:///modules/mcollective/plugins/${type}/${name}.ddl",
      notify => $_service_notify;
    }
  }

}
