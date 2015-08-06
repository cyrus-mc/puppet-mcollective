# == Define: mcollective::plugin
#
#	Resource to install a mcollective plugin
#
# == Parameters
#
#       [namevar]
#               The name of the resources. 
#
#	[type]
#		string, the type of plugin. Valid values are application, 
#		agent, registration
#
#	[ensure]
#		boolean, whether to ensure plugin is present or not
#
#	[ddl]
#		boolean, does a DDL accompany this plugin
#
#	[application]
#		boolean, does an application accompany this plugin
#
#	[plugin_base]
#		string, directory where plugins get installed
#
# == Examples
#
#
# == Authors
#       Author Name <matthew.ceroni@monitise.com>
#
# [Remember: no empty lines between comments and class definition]
define mcollective::plugin ( $type, $ensure = present ) {

  include ::mcollective::params

  if $mcollective::params::supported {

    # default provider of up2date for RH4 doesn't work, override to use yum else
    # fall back to automatic detection
    $pkg_provider = $::operatingsystemmajrelease ? {
        '4'     => 'yum',
        default => undef
    }

    package { "mcollective-${name}-${type}":
      ensure  => $ensure,
      provider => $pkg_provider,
      notify  => Service[ $mcollective::params::service ];
    }

    $template = $type ? {
      'agent'  => "${name}-server.cfg.erb",
      'client' => "${name}-client.cfg.erb",
      default  => undef,
    }

    # concat plugin specific configuration file
    concat::fragment { "server_cfg-${name}-${type}":
      target => "${mcollective::params::c_path}/server.cfg",
      content => template("mcollective/${template}"),
      notify  => Service[ $mcollective::params::service ]
    }
  }

}
