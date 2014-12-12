# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.post_up_message = "Execute ./post-boot.sh to install Selenium in each VM.\nConnect Selenium to http://localhost:44444/wd/hub"

  config.vm.define "IE6_WinXP" do |v|
    v.vm.box = "IE6_WinXP"
    v.vm.box_url = "http://aka.ms/vagrant-xp-ie6"
  end

  config.vm.define "IE8_WinXP" do |v|
    v.vm.box = "IE8_WinXP"
    v.vm.box_url = "http://aka.ms/vagrant-xp-ie8"
  end

  config.vm.define "IE7_Vista" do |v|
    v.vm.box = "IE7_Vista"
    v.vm.box_url = "http://aka.ms/vagrant-vista-ie7"
  end

  config.vm.define "IE8_Win7" do |v|
    v.vm.box = "IE8_Win7"
    v.vm.box_url = "http://aka.ms/vagrant-win7-ie8"
  end

  config.vm.define "IE9_Win7" do |v|
    v.vm.box = "IE9_Win7"
    v.vm.box_url = "http://aka.ms/vagrant-win7-ie9"
  end

  config.vm.define "IE10_Win7" do |v|
    v.vm.box = "IE10_Win7"
    v.vm.box_url = "http://aka.ms/vagrant-win7-ie10"
  end

  config.vm.define "IE11_Win7" do |v|
    v.vm.box = "IE11_Win7"
    v.vm.box_url = "http://aka.ms/vagrant-win7-ie11"
  end

  config.vm.define "IE10_Win8" do |v|
    v.vm.box = "IE10_Win8"
    v.vm.box_url = "http://aka.ms/vagrant-win8-ie10"
  end

  config.vm.define "IE11_Win81" do |v|
    v.vm.box = "IE11_Win81"
    v.vm.box_url = "http://aka.ms/vagrant-win81-ie11"
  end

  config.vm.communicator = "winrm"
  config.winrm.username = "IEUser"
  config.winrm.password = "Passw0rd!"
  config.windows.set_work_network = true

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # config.vm.network "forwarded_port", guest: 80, host: 8080
  config.vm.network "forwarded_port", guest: 4444, host: 44444

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  config.vm.provider "virtualbox" do |vb|
    vb.gui = true
    # Trusting modernie team to set the correct memory settings
    #vb.memory = 1024
    vb.customize ["modifyvm", :id, "--vrde", "on"]
  end
end
