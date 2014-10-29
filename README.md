Mesos Vagrant
===================

A vagrant development environment used to play about with Apache Mesos and PAAS Marathon. The framework is made of duel mesos masters in HA, four mesos slaves, a privately hosted docker register and Jenkins docker build (hub101). You can change the vagrant config in config.yaml

Boxes
-------------
  
    [jest@starfury mesos-vagrant]$ vagrant status
    Current machine states:
  
    mesos-master101           not created (virtualbox)
    mesos-master102           not created (virtualbox)
    mesos-slave101            not created (virtualbox)
    mesos-slave102            not created (virtualbox)
    mesos-slave103            not created (virtualbox)
    mesos-slave104            not created (virtualbox)
    events101                 not created (virtualbox)
    hub101                    not created (virtualbox)

  This environment represents multiple VMs. The VMs are all listed
  above with their current state. For more information about a specific
  VM, run `vagrant status NAME`.

Used to generate a one or more file/configuration files from a hiera based data source

Setup
-------------

The bin/cfg command can be used to generate the rendered file;
  
    [jest@starfury mesos-vagrant]$ vagrant up mesos-master101
    [jest@starfury mesos-vagrant]$ vagrant up mesos-slave10[12]
    [jest@starfury mesos-vagrant]$ vagrant up hub101

Docker Registry
-------------------

The  jenkins / docker registry reads from the following hiera hash (hieradata/common/modules/hub.yaml) and uses it to build out the docker build jobs; Co

    hub::dockers:
      'base':
        repository: https://github.com/gambol99/mesos-vagrant
        dockerfile: Dockerfiles/base
      'dockers-library_redis-2.8.17':
        docker_name: redis
        repository: https://github.com/docker-library/redis
        dockerfile: 2.8.17/
        docker_tag: 2.8.17
      'dockers-library_redis-2.8.16':
        docker_name: redis
        repository: https://github.com/docker-library/redis
        dockerfile: 2.8.16/
        docker_tag: 2.8.16
    ...

