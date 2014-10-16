#
#   Author: Rohith (gambol99@gmail.com)
#   Date: 2014-10-16 17:13:28 +0100 (Thu, 16 Oct 2014)
#
#  vim:ts=2:sw=2:et
#
class hub::config {
  jenkins::plugin {
    [ 'github' ]:
  }
  ->
  jenkins::plugin {
    [ 'token-macro', 'durable-task', 'ssh-slaves' ]:
  }
  ->
  jenkins::plugin {
    [ 'docker-build-step', 'docker-build-publish' ]:
  }
}
