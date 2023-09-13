# Custom vagrant machine for devops - Built on Ubuntu 22.04
Vagrant.configure("2") do |config|
  if Vagrant.has_plugin?("vagrant-hostmanager")
    config.hostmanager.enabled = true
    config.hostmanager.manage_host = true
    config.hostmanager.manage_guest = true

    config.vm.define "jenkins_master" do |master|
      master.vm.box = "mialeevs/ubuntu2204"
      master.vm.box_version = "1.0.0"
      master.vm.network "private_network", ip: "192.168.56.81"
      master.vm.synced_folder "/home/coder/Shared", "/home/vagrant/devops"
      master.vm.network "forwarded_port", guest: 8080, host: 8080
      master.vm.hostname = "jsrvr"
      master.vm.provider "virtualbox" do |vb|
        vb.memory = 2048
        vb.cpus = 2
      end
      master.vm.provision "shell", path: "scripts/jenkins.sh"
    end

    config.vm.define "jenkins_agent" do |agent|
      agent.vm.box = "mialeevs/ubuntu2204"
      agent.vm.box_version = "1.0.0"
      agent.vm.network "private_network", ip: "192.168.56.82"
      agent.vm.synced_folder "/home/coder/Shared", "/home/vagrant/devops"
      agent.vm.synced_folder "/home/coder/jenkins", "/home/vagrant/jenkins"
      agent.vm.hostname = "jagent"
      agent.vm.boot_timeout = 300
      agent.vm.provider "virtualbox" do |vb|
        vb.memory = 2048
        vb.cpus = 2
      end
      agent.vm.provision "shell", path: "scripts/agent.sh"
    end
  
    config.vm.define "jenkins_sonar" do |sonar|
      sonar.vm.box = "mialeevs/ubuntu2204"
      sonar.vm.box_version = "1.0.0"
      sonar.vm.network "private_network", ip: "192.168.56.83"
      sonar.vm.synced_folder "/home/coder/Shared", "/home/vagrant/devops"
      sonar.vm.network "forwarded_port", guest: 9000, host: 9000
      sonar.vm.hostname = "jsonar"
      sonar.vm.boot_timeout = 300
      sonar.vm.provider "virtualbox" do |vb|
        vb.memory = 4096
        vb.cpus = 2
      end
      sonar.vm.provision "shell", path: "scripts/docker.sh"
      #sonar.vm.provision "shell", path: "scripts/sonar.sh"
    end
    
  end
end
