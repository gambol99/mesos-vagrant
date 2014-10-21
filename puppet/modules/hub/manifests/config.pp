#
#   Author: Rohith (gambol99@gmail.com)
#   Date: 2014-10-16 17:13:28 +0100 (Thu, 16 Oct 2014)
#
#  vim:ts=2:sw=2:et
#
class hub::config {
  user { 'jenkins':
    groups  => [ 'docker', 'jenkins'],
  }

  jenkins::job::present { 'docker-publish':
    config  => template("${module_name}/jenkins/jobs/docker-publish.xml.erb"),
    jobname => 'docker-publish',
  }

  jenkins::plugin { 'docker-build-step':
    manage_config   => true,
    config_filename => 'org.jenkinsci.plugins.dockerbuildstep.DockerBuilder.xml',
    config_content  => template("${module_name}/jenkins/plugins/DockerBuilder.xml.erb"),
  }

  create_resources( 'jenkins::plugin', $hub::jenkins_plugins, {
    manage_config => false
  } )

  create_resources( 'hub::docker::build', $hub::docker_builds, {
    user       => 'gambol99',
    docker_tag => 'latest',
  })
}
