# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = '2'
SERVER_ROOT_PASSWORD    = 'TumZcbpMs-vTbDU58a_X'
DEV_DB                  = 'dev'
DEV_DB_USER             = 'dev'
DEV_DB_PASSWORD         = 'dev'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.


  config.vm.network "private_network", ip: "192.168.50.4"
  config.vm.synced_folder ".", "/vagrant", type: "nfs"
  config.vm.synced_folder ".", "/vagrant"
  config.vm.provider "virtualbox" do |v|
    v.memory = 2800
    v.ioapic = "on"
    # v.customize ["modifyvm", :id, "--cpuexecutioncap", "80"]
    v.customize ["modifyvm", :id, "--cpus", "2"]
  end

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = 'debian_wheezy_amd64'

  # Forward mysql port
  config.vm.network :forwarded_port, guest: 3306, host: 13306

  # FIX: Sometimes on OSX we get an error like "to many files open"
  #      this line will fix this error
  #config.vm.provision :shell, inline: "ulimit -n 4048"

  config.berkshelf.enabled = true
  config.berkshelf.berksfile_path = 'vagrant/Berksfile'

  config.vm.provision :chef_solo do |chef|
    chef.add_recipe 'apt'
    chef.add_recipe 'git'
    chef.add_recipe 'libqt'
    chef.add_recipe 'build-essential'
    chef.add_recipe 'mysql::server'
    chef.add_recipe 'ruby_build'
    chef.add_recipe 'rbenv::user'
    chef.add_recipe 'imagemagick'

    ruby_version = '2.0.0-p353'

    chef.json = {
      mysql: {
        server_root_password:   SERVER_ROOT_PASSWORD,
        server_repl_password:   SERVER_ROOT_PASSWORD,
        server_debian_password: SERVER_ROOT_PASSWORD
      },
      rbenv: {
        user_installs: [
          {
            user: 'vagrant',
            rubies: [ruby_version],
            global: ruby_version,
            gems: {
              ruby_version => [
                { name: 'bundler' },
                { name: 'pry' },
                { name: 'rake' }
              ]
            }
          }
        ]
      },
    }
  end

  # Sets some environment variables for the vagrant user
  config.vm.provision :shell, inline: "cat /vagrant/vagrant/exports.sh >> /home/vagrant/.bashrc"
  config.vm.provision :shell, inline: 'cp /vagrant/vagrant/database.yml /vagrant/config/database.yml'

  # Init databases
  config.vm.provision :shell, inline: "mysql -u root -p#{SERVER_ROOT_PASSWORD} -e \"CREATE DATABASE IF NOT EXISTS #{DEV_DB}\""
  config.vm.provision :shell, inline: "mysql -u root -p#{SERVER_ROOT_PASSWORD} -e \"GRANT ALL ON #{DEV_DB}.* TO '#{DEV_DB_USER}'@'%' IDENTIFIED BY '#{DEV_DB_PASSWORD}'; FLUSH PRIVILEGES;\""
  config.vm.provision :shell, inline: "mysql -u root -p#{SERVER_ROOT_PASSWORD} -e \"CREATE DATABASE IF NOT EXISTS test\""
  config.vm.provision :shell, inline: "mysql -u root -p#{SERVER_ROOT_PASSWORD} -e \"GRANT ALL ON test.* TO 'test'@'localhost' IDENTIFIED BY 'test'; FLUSH PRIVILEGES;\""

end
