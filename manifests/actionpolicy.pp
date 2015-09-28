# Define: mcollective::actionpolicy
#
# This class manages a mcollective server (package, service and config)
#
# Requires:
#
define mcollective::actionpolicy (
  $ensure,
  $default_policy
  ) {

  include mcollective::params

  # this node must be configured as a mcollective server
  if ! defined(Class['mcollective::server']) {
    fail('You must declare mcollective::server class before you can use mcollective::actionpolicy')
  }

  # validate parameters
  validate_re($ensure, '^(present|absent)$',
    "\$ensure must be either 'present' or 'absent', got '${ensure}'")

  validate_re($default_policy, '^(allow|deny)$',
    "\$default_policy must be either 'allow' or 'deny', got '${default_policy}'")

  concat { "${mcollective::params::config_path}/policies/${name}.policy":
    ensure => $ensure,
  }

  concat::fragment { "mcollective.actionpolicy.${name}":
    target  => "${mcollective::params::config_path}/policies/${name}.policy",
    content => "policy default ${default_policy}\n",
    order   => '00',
  }

}
