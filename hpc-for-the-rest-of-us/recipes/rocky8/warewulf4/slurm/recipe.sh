#!/bin/bash

# Uncomment the MAC Address for your cluster compute node

# hpcc-cluster-1
#mac_address=40:F2:E9:02:48:B8

# hpcc-cluster-2
#mac_address=34:40:b5:b9:40:37

# hpcc-cluster-3
#mac_address=34:40:b5:b9:9d:8c

# hpcc-cluster-4
#mac_address=34:40:b5:b9:7d:1b

# hpcc-cluster-5
#mac_address=34:40:b5:b9:63:33

# hpcc-cluster-6
#mac_address=40:F2:E9:05:40:38

# hpcc-cluster-7
#mac_address=34:40:b5:b9:fa:b2

# hpcc-cluster-8
#mac_address=34:40:b5:b9:d1:c2

# hpcc-cluster-9
#mac_address=34:40:b5:b9:0a:1b

# hpcc-cluster-10
#mac_address=34:40:b5:b9:05:14

domainname cluster

hostname `hostname -s`

hostnamectl set-hostname `hostname -s`

echo 10.1.1.1 `hostname -s`.cluster `hostname -s` >> /etc/hosts

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

dnf -y install singularity

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

systemctl --root=$CHROOT enable chronyd.service

perl -pi -e "s/pool 2.pool.ntp.org iburst/server 10.1.1.1/" $CHROOT/etc/chrony.conf 

dnf -y --installroot=$CHROOT install lua lua-filesystem lua-posix

wwctl overlay mkdir generic /etc/profile.d

wwctl overlay import generic /etc/profile.d/lmod.sh

wwctl overlay import generic /etc/profile.d/lmod.csh

dnf -y install intel-oneapi-toolkit-release-ohpc

dnf -y install intel-hpckit

dnf -y install intel-compilers-devel-ohpc intel-mpi-devel-ohpc

dnf -y --installroot=$CHROOT install gcc libstdc++-devel cmake

ssh-keygen -t rsa

cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

cp --parents ~/.ssh/authorized_keys $CHROOT/root/

yum -y groupinstall "InfiniBand Support"

yum -y --installroot=$CHROOT groupinstall "InfiniBand Support"

perl -pi -e 's/# End of file/\* soft memlock unlimited\n$&/s' /etc/security/limits.conf
perl -pi -e 's/# End of file/\* hard memlock unlimited\n$&/s' /etc/security/limits.conf
perl -pi -e 's/# End of file/\* soft memlock unlimited\n$&/s' ${CHROOT}/etc/security/limits.conf
perl -pi -e 's/# End of file/\* hard memlock unlimited\n$&/s' ${CHROOT}/etc/security/limits.conf

dnf -y install pmix-ohpc

dnf -y install ohpc-slurm-server

dnf -y --installroot=$CHROOT install ohpc-slurm-client

cp /etc/slurm/slurm.conf.ohpc /etc/slurm/slurm.conf

perl -pi -e "s/ControlMachine=\S+/ControlMachine=`hostname -s`/" /etc/slurm/slurm.conf

perl -pi -e "s/^NodeName=(\S+)/NodeName=compute-1-1/" /etc/slurm/slurm.conf

perl -pi -e "s/^PartitionName=normal Nodes=(\S+)/PartitionName=normal Nodes=compute-1-1/" /etc/slurm/slurm.conf

perl -pi -e "s/ Nodes=c\S+ / Nodes=ALL /" /etc/slurm/slurm.conf

perl -pi -e "s/ReturnToService=1/ReturnToService=2/" /etc/slurm/slurm.conf

chroot $CHROOT systemctl enable munge

chroot $CHROOT systemctl enable slurmd

echo SLURMD_OPTIONS="--conf-server `hostname -s`" > $CHROOT/etc/sysconfig/slurmd

cp /etc/munge/munge.key $CHROOT/etc/munge/

chroot $CHROOT chown munge.munge /etc/munge/munge.key

systemctl enable munge
systemctl start munge
systemctl enable slurmctld
systemctl start slurmctld

useradd test

cp /etc/passwd /etc/group /etc/shadow $CHROOT/etc/

echo '{{Include "/etc/passwd"}}' >> /var/lib/warewulf/overlays/generic/etc/passwd.ww

cat << EOT >> $CHROOT/etc/warewulf/excludes
/opt/*
/home/*
/tmp/*
/var/log/*
/var/run/*
EOT

wwctl container build rocky-8

wwctl node add compute-1-1 -n cluster -I 10.10.1.1 -H ${mac_address}

wwctl node set compute-1-1 -A "quiet crashkernel=no vga=791 rootfstype=ramfs"

wwctl configure --all

wwctl overlay build

wwctl server restart

ipmitool -H 10.2.2.2 -U USERID -P PASSW0RD chassis power cycle
