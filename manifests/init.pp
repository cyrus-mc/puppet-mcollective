# == Class: mcollective
#
#	This modules managed mcollective and installs necessary packages
#	based on whether the node is a client or server (or both)
#
# === Parameters
#
#       [is_client]
#               boolean, specify whether the host is a mcollective client. The
#               default value is specified in mcollective::params::is_client
#
#       [is_server]
#               boolean, specify whether the host is a mcollective server. The
#               default value is specified in mcollective::params::is_server
#
# === Variables
#
#  none
#
# === Examples
#
#	class { "mcollective":
#		is_client	=> false,
#		is_server	=> true,
#
# === Authors
#
# cyrus
#
# === Copyright
#
# Copyright 2013 cyrus, unless otherwise noted.
#
# [Remember: no empty lines between comments and class definition]
class mcollective ( $is_client = hiera('mcollective::is_client', $mcollective::params::is_client), 
		    $is_server = hiera('mcollective::is_server', $mcollective::params::is_server) ) inherits mcollective::params {

	# only run if on a supported platform
	if $mcollective::params::supported {

		if $is_client {
			package { $mcollective::params::packages_client: 
				ensure	=> present,
			}
		}

		if $is_server {
			package { $mcollective::params::packages_server:
				ensure	=> present,
			}
		}

	}

}
