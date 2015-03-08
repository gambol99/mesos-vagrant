#
#   Author: Rohith
#   Date: 2015-03-08 13:36:29 +0000 (Sun, 08 Mar 2015)
#
#  vim:ts=2:sw=2:et
#

.PHONY: update jenkins

jenkins:
	vagrant up hub101

update:
	git pull
	git submodule foreach git pull origin master
