#!/bin/bash
# -----------------------------------------------------------------------------------------
#  The following installation script is based on recipes from Intel, installation
#  guides from Warewulf, and installation processes from the Stanford HPC Center.
#
#  This script uses inputs that describe local hardware characteristics, desired
#  network settings, and other customizations specific to the Stanford High 
#  Performance Computing Center Teaching Clusters.
#
# -----------------------------------------------------------------------------------------

date

sms_name=`hostname -s`
sms_ip="10.1.1.1"
ntp_server="time.stanford.edu"
sms_eth_internal="enp6s0f1"

if [ $sms_name = hpcc-cluster-1 ]
then
        mac_address=40:F2:E9:02:48:B8

elif [ $sms_name = hpcc-cluster-2 ]
then
        mac_address=34:40:b5:b9:40:37

elif [ $sms_name = hpcc-cluster-3 ]
then
        mac_address=34:40:b5:b9:9d:8c

elif [ $sms_name = hpcc-cluster-4 ]
then
        mac_address=34:40:b5:b9:7d:1b

elif [ $sms_name = hpcc-cluster-5 ]
then
        mac_address=34:40:b5:b9:63:33

elif [ $sms_name = hpcc-cluster-6 ]
then
        mac_address=34:40:b5:b9:ca:f8

elif [ $sms_name = hpcc-cluster-7 ]
then
        mac_address=34:40:b5:b9:fa:b2

elif [ $sms_name = hpcc-cluster-8 ]
then
        mac_address=34:40:b5:b9:d1:c2

elif [ $sms_name = hpcc-cluster-9 ]
then
        mac_address=34:40:b5:b9:0a:1b

elif [ $sms_name = hpcc-cluster-10 ]
then
        mac_address=34:40:b5:b9:05:14

elif [ $sms_name = hpcc-cluster-11 ]
then
        mac_address=34:40:b5:b9:40:9b

elif [ $sms_name = hpcc-cluster-12 ]
then
        mac_address=34:40:b5:b9:47:4b

elif [ $sms_name = hpcc-cluster-13 ]
then
        mac_address=34:40:b5:b9:94:1b

elif [ $sms_name = hpcc-cluster-14 ]
then
        mac_address=34:40:b5:b9:47:67

elif [ $sms_name = hpcc-cluster-15 ]
then
        mac_address=34:40:b5:b9:0d:c7

elif [ $sms_name = hpcc-cluster-16 ]
then
        mac_address=34:40:b5:b9:3e:6e

elif [ $sms_name = hpcc-cluster-17 ]
then
        mac_address=34:40:b5:b9:44:b0

elif [ $sms_name = hpcc-cluster-18 ]
then
        mac_address=34:40:b5:b9:46:fb

elif [ $sms_name = hpcc-cluster-19 ]
then
        mac_address=34:40:b5:b9:43:62

elif [ $sms_name = hpcc-cluster-20 ]
then
        mac_address=34:40:b5:b9:45:29

elif [ $sms_name = hpcc-cluster-21 ]
then
        mac_address=34:40:b5:b9:42:8e

elif [ $sms_name = hpcc-cluster-22 ]
then
        mac_address=34:40:B5:B9:63:5A

elif [ $sms_name = hpcc-cluster-23 ]
then
        mac_address=34:40:b5:b9:92:9c

elif [ $sms_name = hpcc-cluster-24 ]
then
        mac_address=34:40:b5:b9:46:75

elif [ $sms_name = hpcc-cluster-25 ]
then
        mac_address=34:40:b5:b9:46:b4

elif [ $sms_name = hpcc-cluster-26 ]
then
        mac_address=34:40:b5:b9:39:9c

elif [ $sms_name = hpcc-cluster-27 ]
then
        mac_address=34:40:b5:b9:47:2e

elif [ $sms_name = hpcc-cluster-28 ]
then
        mac_address=34:40:b5:b9:1d:11

elif [ $sms_name = hpcc-cluster-29 ]
then
        mac_address=34:40:b5:b9:3c:30

elif [ $sms_name = hpcc-cluster-30 ]
then
        mac_address=34:40:b5:b9:43:b3

elif [ $sms_name = hpcc-cluster-31 ]
then
        mac_address=40:f2:e9:02:77:e8

elif [ $sms_name = hpcc-cluster-32 ]
then
        mac_address=34:40:b5:b9:2f:f2

elif [ $sms_name = hpcc-cluster-33 ]
then
        mac_address=34:40:b5:b8:fb:8c

elif [ $sms_name = hpcc-cluster-34 ]
then
        mac_address=34:40:b5:b9:3a:a7
        
elif [ $sms_name = hpcc-cluster-35 ]
then
        mac_address=34:40:b5:b9:08:e2

elif [ $sms_name = hpcc-cluster-36 ]
then
        mac_address=34:40:b5:b9:47:99

elif [ $sms_name = hpcc-cluster-37 ]
then
        mac_address=34:40:b5:b9:06:76

elif [ $sms_name = hpcc-cluster-38 ]
then
        mac_address=34:40:b5:b9:05:c7

elif [ $sms_name = hpcc-cluster-39 ]
then
        mac_address=34:40:b5:b9:0c:63

elif [ $sms_name = hpcc-cluster-40 ]
then
        mac_address=34:40:b5:b8:fe:21
        
elif [ $sms_name = hpcc-cluster-41 ]
then
        mac_address=34:40:b5:b9:80:43
        
elif [ $sms_name = hpcc-cluster-42 ]
then
        mac_address=34:40:b5:b9:07:26

elif [ $sms_name = hpcc-cluster-43 ]
then
        mac_address=34:40:b5:b9:94:08

elif [ $sms_name = hpcc-cluster-44 ]
then
        mac_address=34:40:b5:b9:02:00

elif [ $sms_name = hpcc-cluster-45 ]
then
        mac_address=34:40:b5:b9:32:d2
        
elif [ $sms_name = hpcc-cluster-46 ]
then
        mac_address=34:40:b5:b9:07:b4

elif [ $sms_name = hpcc-cluster-47 ]
then
        mac_address=34:40:b5:b9:c3:04

elif [ $sms_name = hpcc-cluster-48 ]
then
        mac_address=34:40:b5:b9:94:41

elif [ $sms_name = hpcc-cluster-49 ]
then
        mac_address=34:40:b5:b9:5a:5a
        
elif [ $sms_name = hpcc-cluster-50 ]
then
        mac_address=34:40:b5:b9:65:FA

elif [ $sms_name = hpcc-cluster-51 ]
then
        mac_address=34:40:b5:ba:1e:07

elif [ $sms_name = hpcc-cluster-52 ]
then
        mac_address=34:40:b5:b9:68:5e

elif [ $sms_name = hpcc-cluster-53 ]
then
        mac_address=40:f2:e9:02:5c:fc

elif [ $sms_name = hpcc-cluster-54 ]
then
        mac_address=34:40:b5:b9:64:b2

elif [ $sms_name = hpcc-cluster-55 ]
then
        mac_address=34:40:b5:b9:65:b4

elif [ $sms_name = hpcc-cluster-56 ]
then
        mac_address=34:40:b5:b9:4a:56

elif [ $sms_name = hpcc-cluster-57 ]
then
        mac_address=34:40:b5:b9:65:49

elif [ $sms_name = hpcc-cluster-58 ]
then
        mac_address=34:40:b5:b9:4a:15

elif [ $sms_name = hpcc-cluster-59 ]
then
        mac_address=34:40:b5:b9:56:bd

elif [ $sms_name = hpcc-cluster-60 ]
then
        mac_address=34:40:b5:b9:b5:e2

elif [ $sms_name = hpcc-cluster-61 ]
then
        mac_address=34:40:b5:b9:57:42

elif [ $sms_name = hpcc-cluster-62 ]
then
        mac_address=34:40:b5:b9:57:e9

elif [ $sms_name = hpcc-cluster-63 ]
then
        mac_address=34:40:b5:b9:59:9f

elif [ $sms_name = hpcc-cluster-64 ]
then
        mac_address=34:40:b5:b9:46:18

fi

hostname `hostname -s`

hostnamectl set-hostname `hostname -s`

dnf -y install ohpc-base

dnf -y install tftp-server nfs-utils dhcp-server

groupadd -r warewulf

dnf -y install golang rpmdevtools

rpmdev-setuptree

wget https://github.com/hpcng/warewulf/archive/refs/tags/v4.3.0.zip

unzip v4.3.0.zip

tar -zcf /root/rpmbuild/SOURCES/warewulf-4.3.0.tar.gz warewulf-4.3.0

cd warewulf-4.3.0

make config

cp warewulf.spec /root/rpmbuild/SPECS/

cd ..

rpmbuild -bb /root/rpmbuild/SPECS/warewulf.spec

dnf -y install /root/rpmbuild/RPMS/x86_64/warewulf-4.3.0-1.el8.x86_64.rpm

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

wwctl profile set -y default --netdev eth0 --netmask 255.240.0.0 --gateway 10.1.1.1 --type ethernet --onboot yes

wwctl configure --all

dnf -y install gcc

dnf -y install gnu9-compilers-ohpc

dnf -y install gnu12-compilers-ohpc

perl -pi -e "s/family \"compiler\"//" /opt/ohpc/pub/modulefiles/gnu9/9.4.0

perl -pi -e "s/family\(\"compiler\"\)//" /opt/ohpc/pub/modulefiles/gnu12/12.2.0.lua


# singularity fix

dnf install -y apptainer


dnf -y install dmidecode numactl-libs numactl-devel mlocate rpm-build wget

wwctl container import docker://warewulf/rocky:8 rocky-8 --setdefault

echo export CHROOT=/var/lib/warewulf/chroots/rocky-8/rootfs >> /root/.bash_profile

. /root/.bash_profile

useradd test

echo password | passwd --stdin test

wwctl container syncuser --write rocky-8

dnf --installroot=$CHROOT config-manager --setopt="install_weak_deps=False" --save

dnf --installroot=$CHROOT config-manager --set-enabled powertools

dnf -y --installroot=$CHROOT install http://repos.openhpc.community/OpenHPC/2/EL_8/x86_64/ohpc-release-2-1.el8.x86_64.rpm

# dnf --installroot=$CHROOT config-manager --add-repo http://yum.repos.intel.com/hpc-platform/el8/setup/intel-hpc-platform.repo

# rpm --root=$CHROOT --import http://yum.repos.intel.com/hpc-platform/el8/setup/PUBLIC_KEY.PUB

dnf -y --installroot=$CHROOT update

dnf -y --installroot=$CHROOT install kernel-modules

dnf -y --installroot=$CHROOT remove --oldinstallonly

dnf -y --installroot=$CHROOT install apptainer

dnf -y --installroot=$CHROOT install ohpc-base-compute

# dnf -y --installroot=$CHROOT install "intel-hpc-platform-*"

dnf -y --installroot=$CHROOT install dmidecode parted grub2 numactl chrony

systemctl --root=$CHROOT enable chronyd.service

perl -pi -e "s/pool 2.rocky.pool.ntp.org iburst/server 10.1.1.1/" $CHROOT/etc/chrony.conf 

dnf -y --installroot=$CHROOT install lua lua-filesystem lua-posix

wwctl overlay mkdir generic /etc/profile.d

wwctl overlay import generic /etc/profile.d/lmod.sh

wwctl overlay import generic /etc/profile.d/lmod.csh

dnf -y --installroot=$CHROOT install gcc libstdc++-devel cmake

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

cp /etc/slurm/cgroup.conf.example /etc/slurm/cgroup.conf

perl -pi -e "s/SlurmctldHost=\S+/SlurmctldHost=`hostname -s`/" /etc/slurm/slurm.conf

perl -pi -e "s/JobCompType\=jobcomp\/filetxt/\\#JobCompType\=jobcomp\/filetxt/" /etc/slurm/slurm.conf
sed -i '59s/TaskPlugin\=task\/affinity/\#TaskPlugin\=task\/affinity/g' /etc/slurm/slurm.conf

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

dnf -y install opensm
systemctl enable opensm
systemctl start opensm

cat << EOT >> $CHROOT/etc/warewulf/excludes
/opt/*
/home/*
/tmp/*
/var/log/*
/var/run/*
EOT

# ----------------------------
# Updates to recipe.sh for HPC for the rest of us! tutorials
# ----------------------------

# added for paraview
yum -y --installroot=$CHROOT install mesa-libGLU

# add python3.11
yum -y --installroot=$CHROOT install python3.11 python3.11-pip

wwctl container build rocky-8

wwctl node add compute-1-1 -n cluster -I 10.10.1.1 -H ${mac_address}

wwctl node set -y compute-1-1 -A "quiet crashkernel=no vga=791 rootfstype=ramfs"

wwctl configure --all

wwctl overlay build

wwctl server restart

ipmitool -H 10.2.2.2 -U USERID -P PASSW0RD chassis power cycle

# dnf -y install intel-oneapi-toolkit-release-ohpc

# dnf -y install intel-hpckit

# dnf -y install intel-compilers-devel-ohpc intel-mpi-devel-ohpc

date
