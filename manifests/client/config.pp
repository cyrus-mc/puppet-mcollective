 == Class: mcollective::server::config
#
#       This class configures, manages a mcollective client 
#
#       This module has been tested on the following platforms:
#               - CentOS v6.x
#               - Red Hat Enterprise Linux v6.x
#
# === Parameters
#
#       [host]
#               string, the activemq server to connect to. The default value
#               is specified by mcollective::params::host.
#
#       [port]
#               string, the activemq server port. The default value
#               is specified by mcollective::params::port.
#
#       [user]
#               string, the user used to authenticate against the activemq
#               server. Default valvue is mcollective::params::user
#
#       [passwd]
#               string, the password used to authenticate against the
#               activemq server. Default value is mcollective::params::passwd
#
# === Examples
#
#               class { "mcollective::client::config":
#                       host    => 'localhost',
#               }
# === Authors
#
#       Author Name <matthew.ceroni@monitise.com>
#
# [Remember: no empty lines between comments and class definition]
class mcollective::client::config (
	$connector = $mcollective::params::connector,
	$host = $mcollective::params::host,
	$port = $mcollective::params::port,
	$user = $mcollective::params::user,
	$passwd = $mcollective::params::passwd) inherits mcollective::params {

	$psk = $mcollective::params::psk

        # only run if on a supported platform
        if $mcollective::params::supported {

		class { "mcollective":
			is_client => true,
		}

		# configure mcollective client
		file { "/etc/mcollective/client.cfg":
			ensure	=> file,
			owner	=> root,
			group	=> root,
			mode	=> 0600,
			content	=> template("mcollective/client.${connector}.cfg.erb"),
		}

		# set the order
		Class[ "mcollective" ] -> File[ "/etc/mcollective/client.cfg" ]
	}
}
