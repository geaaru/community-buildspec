# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure(2) do |config|
  config.vm.box = "Sabayon/spinbase-amd64"
  config.vm.provider "virtualbox" do |vb|
    # Display the VirtualBox GUI when booting the machine
     vb.gui = false
     vb.memory = "6096"
     vb.cpus = 3
  end

  config.persistent_storage.enabled = true
  config.persistent_storage.location = './docker_disk.vdi'
  config.persistent_storage.size = 200000
  config.persistent_storage.volgroupname = "docker"
  config.persistent_storage.mountname = "data"

  config.vm.provision "shell", inline: <<-SHELL
    mkdir -p /usr/portage/licenses/
    rsync -av -H -A -X --delete-during "rsync://rsync.at.gentoo.org/gentoo-portage/licenses/" "/usr/portage/licenses/"
    ls /usr/portage/licenses -1 | xargs -0 > /etc/entropy/packages/license.accept

    equo up && sudo equo u
    echo -5 | equo conf update
    equo i docker sabayon-devkit vixie-cron git wget curl ansifilter md5deep dev-perl/JSON dev-perl/libwww-perl dev-python/pip sys-fs/btrfs-progs
    pip install shyaml

    mkdir /etc/systemd/system/docker.service.d/
    echo "[Service]
ExecStart=
ExecStart=/usr/bin/docker daemon --storage-driver=devicemapper --storage-opt dm.datadev=/dev/docker-vg1/data -H fd://
" > /etc/systemd/system/docker.service.d/vagrant_mount.conf
    # append -g /vagrant/docker_cache/ to args to specify a default location


    systemctl daemon-reload

    systemctl enable docker
    systemctl start docker

    systemctl enable vixie-cron
    systemctl start vixie-cron
    crontab /vagrant/confs/crontab
    [ ! -d /vagrant/repositories ] && git clone https://github.com/Sabayon/community-repositories.git /vagrant/repositories
    timedatectl set-ntp true
    echo "@@@@ Provision finished, ensure everything is set up for deploy, suggestion is to reboot the machine to ensure docker is working correctly"
  SHELL

end
