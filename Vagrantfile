# -*- mode: ruby -*-
# # vi: set ft=ruby :

# Specify minimum Vagrant version and Vagrant API version
Vagrant.require_version ">= 1.6.0"
VAGRANTFILE_API_VERSION = "2"

# Check for required plugins
required_plugins = %w(vagrant-hostmanager)
required_plugins.each do |plugin|
  raise "#{plugin} is not installed!" unless Vagrant.has_plugin? plugin
end

# Require YAML module
require 'yaml'

# Read YAML file with box details
servers = YAML.load_file('servers.yaml')

# Create boxes
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  if Vagrant.has_plugin?("vagrant-cachier")
    # Configure cached packages to be shared between instances of the same base box.
    # More info on http://fgrehm.viewdocs.io/vagrant-cachier/usage
    config.cache.scope = :box

    # OPTIONAL: If you are using VirtualBox, you might want to use that to enable
    # NFS for shared folders. This is also very useful for vagrant-libvirt if you
    # want bi-directional sync
    config.cache.synced_folder_opts = {
      type: :nfs,
      # The nolock option can be useful for an NFSv3 client that wants to avoid the
      # NLM sideband protocol. Without this option, apt-get might hang if it tries
      # to lock files needed for /var/cache/* operations. All of this can be avoided
      # by using NFSv4 everywhere. Please note that the tcp option is not the default.
      mount_options: ['rw', 'vers=3', 'tcp', 'nolock']
    }
    # For more information please check http://docs.vagrantup.com/v2/synced-folders/basic_usage.html
  end

  config.hostmanager.enabled = true
  config.hostmanager.manage_host = true
  config.hostmanager.manage_guest = true
  config.hostmanager.ignore_private_ip = false
  config.hostmanager.include_offline = true

  # Iterate through entries in YAML file
  servers.each do |servers|
    config.vm.define servers["name"] do |srv|
      srv.vm.box = servers["box"]
      srv.vm.network "private_network", ip: servers["ip"]
      srv.vm.hostname = servers["hostname"]
      srv.vm.provider :virtualbox do |vb|
        vb.name = servers["name"]
        vb.memory = servers["ram"]
      end
    config.vm.provision "shell", path: servers["provisioning"]
    end
  end
end
