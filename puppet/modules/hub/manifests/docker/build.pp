#
#   Author: Rohith
#   Date: 2014-10-17 21:10:17 +0100 (Fri, 17 Oct 2014)
#
#  vim:ts=2:sw=2:et
#
define hub::docker::build(
  $docker_name = undef,
  $docker_tag  = 'latest',
  $repository  = undef,
  $user        = undef,
  $dockerfile  = ''
) {
  if $docker_name {
    $docker_image_name = $docker_name
  } else {
    $docker_image_name = $name
  }
  jenkins::job::present { $name:
    config  => template("${module_name}/jenkins/jobs/docker.build.xml.erb"),
    jobname => $name,
  }
}
