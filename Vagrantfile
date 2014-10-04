# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"
VAGRANT_CONFIG = "./config.yaml"

Default_Box = [{
  'hostname' => 'ubuntu101',
  'box_name' => 'ubuntu',
  'box_url'  => 'https://oss-binaries.phusionpassenger.com/vagrant/boxes/latest/ubuntu-14.04-amd64-vbox.box',
  'network'  => [
    {
      'name' => 'private_network',
      'ip'   => '10.99.250.10'
    }
  ],
  'spec' => {
    'cpus'   => 1,
    'memory' => 2048,
    'biosbootmenu' => 'disabled'
  }
}]


def vagrant_boxes &block
  @config = ( File.exist?( VAGRANT_CONFIG ) ) ? load_box_config : Default_Box
  @config.each { |x| yield x }
end

def load_box_config
  YAML.load(File.read(VAGRANT_CONFIG)) || []
end

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box_check_update = false
  vagrant_boxes do |settings|
    config.vm.define settings['hostname'] do |x|
      if settings['bootstrap']
        case settings['bootstrap']['type']
        when 'inline'
        when 'script'
          config.vm.provision :shell, :path => settings['bootstrap']['script']
        end
      end
      x.vm.box = settings['box_name']
      x.vm.box_url = settings['box_url']
      x.vm.host_name = settings['hostname'] 
      ( settings['networks'] || [] ).each do |n|
        x.vm.network n['name'], type: :dhcp if n['type'] == 'dhcp'
        x.vm.network n['name'], ip: n['ip'] if n['ip']
      end
      x.vm.provider :virtualbox do |v|
        v.gui   = settings['gui'] || true        
        v.name  = settings['hostname']
        (settings['spec'] || {}).each_pair do |key,value|
          v.customize [ "modifyvm", :id, "--#{key}", value ]
        end
      end
    end
  end
end
