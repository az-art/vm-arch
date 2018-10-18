Vagrant.configure("2") do |config|
  config.vm.box = "arch"
  config.vm.hostname = "arch.local"
  config.ssh.insert_key = false
  #config.vm.network "forwarded_port", guest: 1521, host: 1521
  #config.vbguest.iso_path = "http://download.virtualbox.org/virtualbox/5.2.6/VBoxGuestAdditions_5.2.6.iso"
  #config.vbguest.no_remote = true
  #config.vbguest.auto_reboot = true

  config.vm.provider :virtualbox do |vb|
    vb.name = "ArchLinux VM"
    vb.gui = true
    vb.memory = 8192
    vb.customize ["modifyvm", :id, "--vram", '128']
    vb.customize ["modifyvm", :id, "--accelerate3d", 'on']
    vb.customize ["modifyvm", :id, "--clipboard", 'bidirectional']
  end

  #config.vm.synced_folder ".", "/vagrant", disabled: true
  config.vm.synced_folder "ansible/", "/ansible", type: "rsync"


  config.vm.provision "ansible_local" do |ansible|
    #ansible.install_mode = "pip"
    #ansible.version = "2.4.2.0"
    #ansible.limit = 'localhost'
    ansible.verbose = true
    ansible.inventory_path = '/ansible/hosts'
    ansible.playbook = "/ansible/arch-xfce4.yml"
  end
end
