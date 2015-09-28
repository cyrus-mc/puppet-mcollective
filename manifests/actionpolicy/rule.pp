# Define: mcollective::actionpolicy::rule
#
# This class manages a mcollective server (package, service and config)
#
# Requires:
#
define mcollective::actionpolicy::rule (
  $ensure,
  $agent,
  $rpc_caller,
  $auth,
  $rule_actions,
  $rule_facts,
  $rule_classes,
  $order,
  ) {

  include mcollective::params

  # this node must be configured as a mcollective server
  if ! defined(Mcollective::Actionpolicy[$agent]) {
    fail("You must declare a mcollective::actionpolicy for agent '${agent}' before you can declare rules for it")
  }

  $_rpc_caller = $rpc_caller ? {
    undef   => inline_template('<%= @name.split("@")[0] %>'),
    default => $rpc_caller,
  }

  $_agent = $agent ? {
    undef   => inline_template('<%= @name.split("@")[1] %>'),
    default => $agent,
  }

  # validate parameters
  validate_re($_rpc_caller, '(uid|cert)=\S+',
    "\$rpc_caller must be of the form 'uid=' or 'cert=', got '${rpc_caller}'")

  validate_re($_agent, '^\S+$',
    "Wrong value for \$agent '${agent}'")

  validate_re($ensure, '^(present|absent)$',
    "\$ensure must be either 'present' or 'absent', got '${ensure}'")

  validate_re($auth, '^(allow|deny)$',
    "\$auth must be either 'allow' or 'deny', got '${auth}'")

  validate_array($rule_actions)
  validate_array($rule_facts)
  validate_array($rule_classes)

  concat::fragment { "mcollective.actionpolicy.rule.${name}":
    ensure  => $ensure,
    order   => $order,
    target  => "${mcollective::params::config_path}/policies/${_agent}.policy",
    content => template("${module_name}/actionpolicy.erb"),
  }

}
