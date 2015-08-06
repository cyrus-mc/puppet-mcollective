# == Class: mcollective::facts
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
#	[user]
#		string, the user used to authenticate against the activemq
#		server. Default valvue is mcollective::params::user
#
#	[passwd]
#		string, the password used to authenticate against the
#		activemq server. Default value is mcollective::params::passwd
#
#	[securityprovider]
#		string, the security mechanism to authenticate against the
#		activemq server with. Default value is mcollective::params::securityprovider
#
#	[psk]
#		string, the pre-shared key used to authenticate against the
#		activemq server with. Default value is mcollective::params::psk
#
# === Examples
#
#		class { "mcollective::server::config":
#			host	=> 'localhost',
#		}
# === Authors
#
# cyrus 
#
# === Copyright
#
# Matthew Ceroni <matthew.ceroni@8x8.com>
#
# [Remember: no empty lines between comments and class definition]
class mcollective::facts inherits mcollective::params {

  # only run if on a supported platform
  if $mcollective::params::supported {

    # file resource for facts.yaml
    file {
      "${mcollective::params::c_path}/facts.yaml":
        owner    => root,
        group    => root,
        mode     => '0400',
        loglevel => debug,       # this is needed to avoid it being logged and reported every run
        backup   => false,
        content  => template('mcollective/facts.yaml.erb');
    }

  }
}
