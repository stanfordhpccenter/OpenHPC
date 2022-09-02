#!/bin/bash

domainname cluster

hostname `hostname -s`

hostnamectl set-hostname `hostname -s`

echo 10.1.1.1 `hostname -s`.cluster `hostname -s` >> /etc/hosts

inputFile=${OHPC_INPUT_LOCAL:-/root/input.local}

if [ ! -e ${inputFile} ];then
   echo "Error: Unable to access local input file -> ${inputFile}"
   exit 1
else
   . ${inputFile} || { echo "Error sourcing ${inputFile}"; exit 1; }
fi

dnf -y install ohpc-base

dnf -y install tftp-server nfs-utils dhcp-server

groupadd -r warewulf

dnf -y install golang rpmdevtools

rpmdev-setuptree

wget https://github.com/hpcng/warewulf/archive/refs/tags/v4.3.0rc2.zip

unzip v4.3.0rc2.zip

tar -zcf /root/rpmbuild/SOURCES/warewulf-4.3.0rc2.tar.gz warewulf-4.3.0rc2

cd warewulf-4.3.0rc2

make config

cp warewulf.spec /root/rpmbuild/SPECS/

cd ..

rpmbuild -bb /root/rpmbuild/SPECS/warewulf.spec

dnf -y install /root/rpmbuild/RPMS/x86_64/warewulf-4.3.0rc2-1.el8.x86_64.rpm

systemctl daemon-reload

systemctl enable warewulfd --now

perl -pi -e "s/192.168.200.1/10.1.1.1/" /etc/warewulf/warewulf.conf
perl -pi -e "s/255.255.255.0/255.240.0.0/" /etc/warewulf/warewulf.conf
perl -pi -e "s/192.168.200.0/10.0.0.0/" /etc/warewulf/warewulf.conf
perl -pi -e "s/host overlay: false/host overlay: true/" /etc/warewulf/warewulf.conf
perl -pi -e "s/template: default/template: static/" /etc/warewulf/warewulf.conf
perl -pi -e "s/192.168.200.50/10.10.0.1/" /etc/warewulf/warewulf.conf
perl -pi -e "s/192.168.200.99/10.10.255.254/" /etc/warewulf/warewulf.conf
perl -pi -e "s/mount: false/mount: true/" /etc/warewulf/warewulf.conf
perl -pi -e "s/mount options: \"\"/mount options: defaults/" /etc/warewulf/warewulf.conf

wwctl profile set -y default --netname cluster --netdev eth0 --netmask 255.240.0.0 --gateway 10.1.1.1 --type ethernet --onboot yes

wwctl configure --all

dnf -y install gcc

dnf -y install gnu9-compilers-ohpc

perl -pi -e "s/family \"compiler\"//" /opt/ohpc/pub/modulefiles/gnu9/9.4.0

yum -y install singularity

dnf -y install dmidecode numactl-libs numactl-devel mlocate rpm-build wget

wwctl container import docker://warewulf/rocky:8 rocky-8 --setdefault

echo export CHROOT=/var/lib/warewulf/chroots/rocky-8/rootfs >> /root/.bash_profile

. /root/.bash_profile

dnf --installroot=$CHROOT config-manager --setopt="install_weak_deps=False" --save

dnf --installroot=$CHROOT config-manager --set-enabled powertools

dnf -y --installroot=$CHROOT install http://repos.openhpc.community/OpenHPC/2/EL_8/x86_64/ohpc-release-2-1.el8.x86_64.rpm

dnf --installroot=$CHROOT config-manager --add-repo http://yum.repos.intel.com/hpc-platform/el8/setup/intel-hpc-platform.repo

rpm --root=$CHROOT --import http://yum.repos.intel.com/hpc-platform/el8/setup/PUBLIC_KEY.PUB

dnf -y --installroot=$CHROOT update

dnf -y --installroot=$CHROOT install kernel-modules

dnf -y --installroot=$CHROOT remove --oldinstallonly

dnf -y --installroot=$CHROOT install ohpc-base-compute

dnf -y --installroot=$CHROOT install "intel-hpc-platform-*"

dnf -y --installroot=$CHROOT install singularity

dnf -y --installroot=$CHROOT install dmidecode parted grub2 numactl chrony
