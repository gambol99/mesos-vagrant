#
#   Author: Rohith (gambol99@gmail.com)
#   Date: 2014-10-16 17:13:28 +0100 (Thu, 16 Oct 2014)
#
#  vim:ts=2:sw=2:et
#
class hub::config {
  $docker_builds = hiera_hash('hub::dockers',{})

  jenkins::plugin {
    $hub::jenkins_plugins:
  }
  ->
  jenkins::job::present { 'docker-publish':
    config  => template("${module_name}/jenkins/jobs/docker-publish.xml.erb"),
    jobname => 'docker-publish',
  }

  create_resources( 'hub::docker::build', $docker_builds, {
    user       => 'gambol99',
    docker_tag => 'latest',
  })
}
