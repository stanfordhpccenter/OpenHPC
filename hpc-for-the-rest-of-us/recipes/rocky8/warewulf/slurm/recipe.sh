#!/bin/bash
# -----------------------------------------------------------------------------------------
#  Example Installation Script Template
#
#  This convenience script encapsulates command-line instructions highlighted in
#  an OpenHPC Install Guide that can be used as a starting point to perform a local
#  cluster install beginning with bare-metal. Necessary inputs that describe local
#  hardware characteristics, desired network settings, and other customizations
#  are controlled via a companion input file that is used to initialize variables
#  within this script.
#
#  Please see the OpenHPC Install Guide(s) for more information regarding the
#  procedure. Note that the section numbering included in this script refers to
#  corresponding sections from the companion install guide.
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

elif [ $sms_name = hpcc-cluster-65 ]
then
        mac_address=34:40:b5:ba:34:3f

elif [ $sms_name = hpcc-cluster-66 ]
then
        mac_address=34:40:b5:b9:c3:66

elif [ $sms_name = hpcc-cluster-67 ]
then
        mac_address=34:40:b5:b9:65:df

elif [ $sms_name = hpcc-cluster-68 ]
then
        mac_address=34:40:b5:ba:2d:10

fi

# update hosts file
echo $sms_ip $sms_name >> /etc/hosts

# ---------------------------- Begin OpenHPC Recipe ---------------------------------------
# Commands below are extracted from an OpenHPC install guide recipe and are intended for
# execution on the master SMS host.
# -----------------------------------------------------------------------------------------

# Verify OpenHPC repository has been enabled before proceeding

yum repolist | grep -q OpenHPC
if [ $? -ne 0 ];then
   echo "Error: OpenHPC repository must be enabled locally"
   exit 1
fi

# Disable firewall
systemctl disable firewalld
systemctl stop firewalld

# ------------------------------------------------------------
# Add baseline OpenHPC and provisioning services (Section 3.3)
# ------------------------------------------------------------
yum -y install ohpc-base
yum -y install ohpc-warewulf
# Enable NTP services on SMS host
systemctl enable chronyd.service
echo "local stratum 10" >> /etc/chrony.conf
echo "server ${ntp_server}" >> /etc/chrony.conf
echo "allow all" >> /etc/chrony.conf
systemctl restart chronyd

# -------------------------------------------------------------
# Add resource management services on master node (Section 3.4)
# -------------------------------------------------------------
yum -y install ohpc-slurm-server
cp /etc/slurm/slurm.conf.ohpc /etc/slurm/slurm.conf
cp /etc/slurm/cgroup.conf.example /etc/slurm/cgroup.conf
perl -pi -e "s/SlurmctldHost=\S+/SlurmctldHost=${sms_name}/" /etc/slurm/slurm.conf

perl -pi -e "s/JobCompType\=jobcomp\/filetxt/\\#JobCompType\=jobcomp\/filetxt/" /etc/slurm/slurm.conf
sed -i '59s/TaskPlugin\=task\/affinity/\#TaskPlugin\=task\/affinity/g' /etc/slurm/slurm.conf

# ----------------------------------------
# Update node configuration for slurm.conf
# ----------------------------------------

# Update basic slurm configuration

perl -pi -e "s/^NodeName=(\S+)/NodeName=compute-1-1/" /etc/slurm/slurm.conf
perl -pi -e "s/^PartitionName=normal Nodes=(\S+)/PartitionName=normal Nodes=compute-1-1/" /etc/slurm/slurm.conf
perl -pi -e "s/ Nodes=c\S+ / Nodes=ALL /" /etc/slurm/slurm.conf
perl -pi -e "s/ReturnToService=1/ReturnToService=2/" /etc/slurm/slurm.conf

# -----------------------------------------------------------------------
# Optionally add InfiniBand support services on master node (Section 3.5)
# -----------------------------------------------------------------------


yum -y groupinstall "InfiniBand Support"
yum -y install opensm
systemctl enable opensm
systemctl start opensm

# -----------------------------------------------------------
# Complete basic Warewulf setup for master node (Section 3.7)
# -----------------------------------------------------------
perl -pi -e "s/device = eth1/device = ${sms_eth_internal}/" /etc/warewulf/provision.conf
systemctl enable httpd.service
systemctl restart httpd
systemctl enable dhcpd.service
systemctl enable tftp.socket
systemctl start tftp.socket

# -------------------------------------------------
# Create compute image for Warewulf (Section 3.8.1)
# -------------------------------------------------
export CHROOT=/opt/ohpc/admin/images/rocky8.8
echo "export CHROOT=/opt/ohpc/admin/images/rocky8.8" >> ~/.bashrc
wwmkchroot -v rocky-8 $CHROOT
dnf -y --installroot $CHROOT install epel-release
cp -p /etc/yum.repos.d/OpenHPC*.repo $CHROOT/etc/yum.repos.d

# ------------------------------------------------------------
# Add OpenHPC base components to compute image (Section 3.8.2)
# ------------------------------------------------------------
yum -y --installroot=$CHROOT install ohpc-base-compute

# -------------------------------------------------------
# Add OpenHPC components to compute image (Section 3.8.2)
# -------------------------------------------------------
cp -p /etc/resolv.conf $CHROOT/etc/resolv.conf
# Add SLURM and other components to compute instance
cp /etc/passwd /etc/group  $CHROOT/etc
yum -y --installroot=$CHROOT install ohpc-slurm-client
yum -y --installroot=$CHROOT install hwloc
chroot $CHROOT systemctl enable munge
chroot $CHROOT systemctl enable slurmd
echo SLURMD_OPTIONS="--conf-server ${sms_ip}" > $CHROOT/etc/sysconfig/slurmd
yum -y --installroot=$CHROOT install chrony
echo "server ${sms_ip} iburst" >> $CHROOT/etc/chrony.conf
yum -y --installroot=$CHROOT install kernel-`uname -r`
yum -y --installroot=$CHROOT install lmod-ohpc

# ----------------------------------------------
# Customize system configuration (Section 3.8.3)
# ----------------------------------------------
wwinit database
wwinit ssh_keys
echo "${sms_ip}:/home /home nfs nfsvers=3,nodev,nosuid 0 0" >> $CHROOT/etc/fstab
echo "${sms_ip}:/opt/ohpc/pub /opt/ohpc/pub nfs nfsvers=3,nodev 0 0" >> $CHROOT/etc/fstab
echo "/home *(rw,no_subtree_check,fsid=10,no_root_squash)" >> /etc/exports
echo "/opt/ohpc/pub *(ro,no_subtree_check,fsid=11)" >> /etc/exports

mkdir /opt/intel
echo "/opt/intel *(ro,no_subtree_check,fsid=12)" >> /etc/exports
echo "${sms_ip}:/opt/intel /opt/intel nfs nfsvers=3,nodev 0 0" >> $CHROOT/etc/fstab

exportfs -a
systemctl restart nfs-server
systemctl enable nfs-server

# -----------------------------------------
# Additional customizations (Section 3.8.4)
# -----------------------------------------

# Add IB drivers to compute image

yum -y --installroot=$CHROOT groupinstall "InfiniBand Support"

# Update memlock settings
perl -pi -e 's/# End of file/\* soft memlock unlimited\n$&/s' /etc/security/limits.conf
perl -pi -e 's/# End of file/\* hard memlock unlimited\n$&/s' /etc/security/limits.conf
perl -pi -e 's/# End of file/\* soft memlock unlimited\n$&/s' $CHROOT/etc/security/limits.conf
perl -pi -e 's/# End of file/\* hard memlock unlimited\n$&/s' $CHROOT/etc/security/limits.conf

# Enable slurm pam module
echo "account    required     pam_slurm.so" >> $CHROOT/etc/pam.d/sshd

# Enable Optional packages

# -------------------------------------------------------
# Configure rsyslog on SMS and computes (Section 3.8.4.7)
# -------------------------------------------------------
echo 'module(load="imudp")' >> /etc/rsyslog.d/ohpc.conf
echo 'input(type="imudp" port="514")' >> /etc/rsyslog.d/ohpc.conf
systemctl restart rsyslog
echo "*.* @${sms_ip}:514" >> $CHROOT/etc/rsyslog.conf
echo "Target=\"${sms_ip}\" Protocol=\"udp\"" >> $CHROOT/etc/rsyslog.conf
perl -pi -e "s/^\*\.info/\\#\*\.info/" $CHROOT/etc/rsyslog.conf
perl -pi -e "s/^authpriv/\\#authpriv/" $CHROOT/etc/rsyslog.conf
perl -pi -e "s/^mail/\\#mail/" $CHROOT/etc/rsyslog.conf
perl -pi -e "s/^cron/\\#cron/" $CHROOT/etc/rsyslog.conf
perl -pi -e "s/^uucp/\\#uucp/" $CHROOT/etc/rsyslog.conf

# Optionally, enable nhc and configure
yum -y install nhc-ohpc
yum -y --installroot=$CHROOT install nhc-ohpc

echo "HealthCheckProgram=/usr/sbin/nhc" >> /etc/slurm/slurm.conf
echo "HealthCheckInterval=300" >> /etc/slurm/slurm.conf  # execute every five minutes


# ----------------------------
# Import files (Section 3.8.5)
# ----------------------------
wwsh file import /etc/passwd
wwsh file import /etc/group
wwsh file import /etc/shadow
wwsh file import /etc/munge/munge.key
wwsh file import /etc/subuid
wwsh file import /etc/subgid

# ----------------------------
# Updates to recipe.sh for HPC for the rest of us! tutorials
# ----------------------------

# added for paraview
yum -y --installroot=$CHROOT install mesa-libGLU

# add apptainer

yum -y --installroot=$CHROOT install apptainer

# --------------------------------------
# Assemble bootstrap image (Section 3.9)
# --------------------------------------
export WW_CONF=/etc/warewulf/bootstrap.conf
echo "drivers += updates/kernel/" >> $WW_CONF
wwbootstrap `uname -r`
# Assemble VNFS
wwvnfs --chroot $CHROOT
# Add hosts to cluster
echo "GATEWAYDEV=eth0" > /tmp/network.$$
wwsh -y file import /tmp/network.$$ --name network
wwsh -y file set network --path /etc/sysconfig/network --mode=0644 --uid=0

wwsh -y node new compute-1-1 -I 10.10.1.1 -H ${mac_address}

# Add hosts to cluster (Cont.)
wwsh -y provision set compute-1-1 --vnfs=rocky8.8 --bootstrap=`uname -r` --files=dynamic_hosts,passwd,group,shadow,munge.key,network,subuid,subgid

systemctl restart dhcpd
wwsh pxe update

# Optionally, enable user namespaces
export kargs="${kargs} namespace.unpriv_enable=1"
echo "user.max_user_namespaces=15076" >> $CHROOT/etc/sysctl.conf
wwvnfs --chroot $CHROOT

# ---------------------------------
# Boot compute nodes (Section 3.10)
# ---------------------------------

ipmitool -E -I lanplus -H 10.2.2.2 -U USERID -P PASSW0RD chassis power reset

# ---------------------------------------
# Install Development Tools (Section 4.1)
# ---------------------------------------
yum -y install ohpc-autotools
# yum -y install EasyBuild-ohpc
# yum -y install hwloc-ohpc
# yum -y install spack-ohpc
# yum -y install valgrind-ohpc

# add apptainer
yum -y install apptainer

# -------------------------------
# Install Compilers (Section 4.2)
# -------------------------------
yum -y install gnu9-compilers-ohpc
yum -y install gnu12-compilers-ohpc

perl -pi -e "s/family \"compiler\"//" /opt/ohpc/pub/modulefiles/gnu9/9.4.0
perl -pi -e "s/family\(\"compiler\"\)//" /opt/ohpc/pub/modulefiles/gnu12/12.2.0.lua

# --------------------------------
# Install MPI Stacks (Section 4.3)
# --------------------------------

# yum -y install mvapich2-gnu9-ohpc

# ---------------------------------------
# Install Performance Tools (Section 4.4)
# ---------------------------------------
# yum -y install ohpc-gnu9-perf-tools

# yum -y install lmod-defaults-gnu9-openmpi4-ohpc

# ---------------------------------------------------
# Install 3rd Party Libraries and Tools (Section 4.6)
# ---------------------------------------------------
# yum -y install ohpc-gnu9-serial-libs
# yum -y install ohpc-gnu9-io-libs
# yum -y install ohpc-gnu9-python-libs
# yum -y install ohpc-gnu9-runtimes
# yum -y install ohpc-gnu9-mpich-parallel-libs
# yum -y install ohpc-gnu9-openmpi4-parallel-libs
# yum -y install ohpc-gnu9-mvapich2-parallel-libs
# yum -y install ohpc-gnu9-mvapich2-parallel-libs

# ----------------------------------------
# Install Intel oneAPI tools (Section 4.7)
# ----------------------------------------
#     yum -y install intel-oneapi-toolkit-release-ohpc
#     rpm --import https://yum.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB
#     yum -y install intel-compilers-devel-ohpc
#     yum -y install intel-mpi-devel-ohpc
#     yum -y install ohpc-intel-serial-libs
#     yum -y install ohpc-intel-geopm
#     yum -y install ohpc-intel-io-libs
#     yum -y install ohpc-intel-perf-tools
#     yum -y install ohpc-intel-python3-libs
#     yum -y install ohpc-intel-mpich-parallel-libs
#     yum -y install ohpc-intel-mvapich2-parallel-libs
#     yum -y install ohpc-intel-openmpi4-parallel-libs
#     yum -y install ohpc-intel-impi-parallel-libs

# ------------------------------------
# Resource Manager Startup (Section 5)
# ------------------------------------
systemctl enable munge
systemctl enable slurmctld
systemctl start munge
systemctl start slurmctld
wwsh ssh compute-* service slurmd restart

useradd -m test
echo password | passwd --stdin test
wwsh file resync passwd shadow group
sleep 2
wwsh ssh compute-* /warewulf/bin/wwgetfiles

date
