# -*- mode: ruby -*-
# # vi: set ft=ruby :

# Specify minimum Vagrant version and Vagrant API version
Vagrant.require_version ">= 1.6.0"
VAGRANTFILE_API_VERSION = "2"

domain = 'vagrant.local'

# Check for required plugins
required_plugins = %w(vagrant-hostmanager vagrant-proxyconf vagrant-cachier)
required_plugins.each do |plugin|
  raise "#{plugin} is not installed!" unless Vagrant.has_plugin? plugin
  exec "vagrant plugin install #{plugin};vagrant #{ARGV.join(" ")}" unless Vagrant.has_plugin? plugin || ARGV[0] == 'plugin'
end

# Require YAML module
require 'yaml'

# Read YAML file with box details
servers = YAML.load_file('servers.yaml')

# Create boxes
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

#  if Vagrant.has_plugin?("")
    #config.cache.scope = :box
      #type: :nfs,
      #mount_options: ['rw', 'vers=3', 'tcp', 'nolock']
    #}
#  end

  config.hostmanager.enabled = true
  config.hostmanager.manage_host = false
  config.hostmanager.manage_guest = true
  config.hostmanager.ignore_private_ip = false
  config.hostmanager.include_offline = false
  config.hostmanager.fqdn_friendly = true
  #config.hostmanager.domain_name = domain
  config.hostmanager.domain_name = "vagrant.local"

  if Vagrant.has_plugin?("vagrant-proxyconf")
    config.proxy.http     = "http://10.200.208.250:3128/"
    config.proxy.https    = "http://10.200.208.250:3128/"
    config.proxy.no_proxy = "localhost,127.0.0.1,.muctst2.elster.de"
  end

  # Iterate through entries in YAML file
  servers.each do |servers|
    config.vm.define servers["name"] do |srv|
      srv.vm.box = servers["box"]
      srv.vm.network "private_network", ip: servers["ip"]
      #srv.vm.hostname = servers["name"] + '.' + domain
      srv.vm.hostname = servers["name"]
      #srv.vm.hostname = servers["name"] + ".vagrant.local"
      config.vm.synced_folder ".", "/vagrant", disabled: servers["DisableSharedFolders"]
      config.vm.provision "shell", path: servers["provisioning"]
      srv.vm.provider :virtualbox do |vb|
        vb.name = servers["name"]
        vb.memory = servers["ram"]
      end
    end
  end
end
