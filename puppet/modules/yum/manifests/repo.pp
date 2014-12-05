#
#   Author: Rohith
#   Date: 2014-11-08 20:01:54 +0000 (Sat, 08 Nov 2014)
#
#  vim:ts=2:sw=2:et
#
define yum::repo(
  $ensure          = 'present',
  $version         = 'stable',
  $use_internal    = false,
  $repository
) {

  file {
    "/etc/yum.repos.d/${name}.repo":
      ensure  => $ensure,
      mode    => '0444';
  }

  if $ensure == 'present' {
    File["/etc/yum.repos.d/${name}.repo"] {
      content => template("${module_name}/yum.repos.d/yum_repo_template.erb"),
      notify  => Exec["updating the yum cache for repo ${name}"],
    }
    $repo_alias = $repository['alias']
    # step: is there a gpg key for this?
    if $repository['gpg'] {
      $gpg_name   = $repository['gpg']
      $gpg_config = hiera('repos::repositories_gpg_keys',{})

    if ! $gpg_config[$gpg_name] {
        fail("unable to find the gpg key: ${gpg_name} in configuration")
      }
      $gpg_dir    = '/etc/pki/rpm-gpg'
      $gpg_file   = "${gpg_dir}/${gpg_name}"
      file {
      $gpg_file:
      ensure    => $ensure,
      mode      => '0444',
      content   => $gpg_config[$gpg_name],
      notify    => Exec["import ${gpg_name} repository gpg key"];
      }
      exec { "import ${gpg_name} repository gpg key":
      path        => ['/bin','/usr/bin', '/usr/sbin'],
      command     => "rpm --import ${gpg_file}",
      refreshonly => true,
      require     => File[$gpg_file],
      }
      }
      exec { "updating the yum cache for repo ${name}":
      # command   => "/usr/bin/yum makecache --disablerepo='*' --enablerepo='${name}*'",
      command     => "true",
      refreshonly => true,
      require     => File["/etc/yum.repos.d/${name}.repo"],
    }
  }
}
