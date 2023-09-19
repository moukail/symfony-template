Vagrant.configure("2") do |config|
  config.vm.box = "generic/centos9s"
  projectDirectory = "/var/www/"
  config.vm.provision :shell, path: ".vagrant/bootstrap.sh"
  config.vm.synced_folder '.', projectDirectory

  config.vm.network :private_network, ip: '192.168.2.50', auto_network: true
  config.vm.network :forwarded_port, guest: 80, host: 8080, id: "web"
  #config.vm.hostname = "moukafih.nl"

  config.ssh.insert_key = false

  config.vm.provider "virtualbox" do |v|
    v.memory = 1024
    v.cpus = 1
  end

  config.trigger.after :up do |trigger|
    trigger.run_remote = {
        :inline => "su - vagrant -c 'cd " + projectDirectory + " && .vagrant/init.sh'"
    }
  end

end