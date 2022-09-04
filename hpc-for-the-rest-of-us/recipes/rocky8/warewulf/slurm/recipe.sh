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

# update hosts file
echo 10.1.1.1 `hostname -s` >> /etc/hosts

inputFile=${OHPC_INPUT_LOCAL:-/root/input.local}

if [ ! -e ${inputFile} ];then
   echo "Error: Unable to access local input file -> ${inputFile}"
   exit 1
else
   . ${inputFile} || { echo "Error sourcing ${inputFile}"; exit 1; }
fi

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
perl -pi -e "s/ControlMachine=\S+/ControlMachine=${sms_name}/" /etc/slurm/slurm.conf

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
if [[ ${enable_ib} -eq 1 ]];then
     yum -y groupinstall "InfiniBand Support"
fi

# Optionally enable opensm subnet manager
if [[ ${enable_opensm} -eq 1 ]];then
     yum -y install opensm
     systemctl enable opensm
     systemctl start opensm
fi

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
export CHROOT=/opt/ohpc/admin/images/rocky8.5
echo "export CHROOT=/opt/ohpc/admin/images/rocky8.5" >> ~/.bashrc
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
if [[ ${enable_intel_packages} -eq 1 ]];then
     mkdir /opt/intel
     echo "/opt/intel *(ro,no_subtree_check,fsid=12)" >> /etc/exports
     echo "${sms_ip}:/opt/intel /opt/intel nfs nfsvers=3,nodev 0 0" >> $CHROOT/etc/fstab
fi
exportfs -a
systemctl restart nfs-server
systemctl enable nfs-server

# -----------------------------------------
# Additional customizations (Section 3.8.4)
# -----------------------------------------

# Add IB drivers to compute image
if [[ ${enable_ib} -eq 1 ]];then
     yum -y --installroot=$CHROOT groupinstall "InfiniBand Support"
fi

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

# --------------------------------------
# Assemble bootstrap image (Section 3.9)
# --------------------------------------
export WW_CONF=/etc/warewulf/bootstrap.conf
echo "drivers += updates/kernel/" >> $WW_CONF
wwbootstrap `uname -r`
# Assemble VNFS
wwvnfs --chroot $CHROOT
# Add hosts to cluster
echo "GATEWAYDEV=${eth_provision}" > /tmp/network.$$
wwsh -y file import /tmp/network.$$ --name network
wwsh -y file set network --path /etc/sysconfig/network --mode=0644 --uid=0
for ((i=0; i<$num_computes; i++)) ; do
   wwsh -y node new ${c_name[i]} --ipaddr=${c_ip[i]} --hwaddr=${c_mac[i]} -D ${eth_provision}
done
# Add hosts to cluster (Cont.)
wwsh -y provision set "${compute_regex}" --vnfs=rocky8.5 --bootstrap=`uname -r` --files=dynamic_hosts,passwd,group,shadow,munge.key,network,subuid,subgid

systemctl restart dhcpd
wwsh pxe update

# Optionally, enable user namespaces
export kargs="${kargs} namespace.unpriv_enable=1"
echo "user.max_user_namespaces=15076" >> $CHROOT/etc/sysctl.conf
wwvnfs --chroot $CHROOT

# ---------------------------------
# Boot compute nodes (Section 3.10)
# ---------------------------------
for ((i=0; i<${num_computes}; i++)) ; do
   ipmitool -E -I lanplus -H ${c_bmc[$i]} -U ${bmc_username} -P ${bmc_password} chassis power reset
done

# ---------------------------------------
# Install Development Tools (Section 4.1)
# ---------------------------------------
yum -y install ohpc-autotools
yum -y install EasyBuild-ohpc
yum -y install hwloc-ohpc
yum -y install spack-ohpc
yum -y install valgrind-ohpc

# -------------------------------
# Install Compilers (Section 4.2)
# -------------------------------
yum -y install gnu9-compilers-ohpc

# --------------------------------
# Install MPI Stacks (Section 4.3)
# --------------------------------
if [[ ${enable_mpi_defaults} -eq 1 && ${enable_pmix} -eq 0 ]];then
     yum -y install openmpi4-gnu9-ohpc mpich-ofi-gnu9-ohpc
elif [[ ${enable_mpi_defaults} -eq 1 && ${enable_pmix} -eq 1 ]];then
     yum -y install openmpi4-pmix-slurm-gnu9-ohpc mpich-ofi-gnu9-ohpc
fi

if [[ ${enable_ib} -eq 1 ]];then
     yum -y install mvapich2-gnu9-ohpc
fi
if [[ ${enable_opa} -eq 1 ]];then
     yum -y install mvapich2-psm2-gnu9-ohpc
fi

# ---------------------------------------
# Install Performance Tools (Section 4.4)
# ---------------------------------------
yum -y install ohpc-gnu9-perf-tools

if [[ ${enable_geopm} -eq 1 ]];then
     yum -y install ohpc-gnu9-geopm
fi
yum -y install lmod-defaults-gnu9-openmpi4-ohpc

# ---------------------------------------------------
# Install 3rd Party Libraries and Tools (Section 4.6)
# ---------------------------------------------------
yum -y install ohpc-gnu9-serial-libs
yum -y install ohpc-gnu9-io-libs
yum -y install ohpc-gnu9-python-libs
yum -y install ohpc-gnu9-runtimes
if [[ ${enable_mpi_defaults} -eq 1 ]];then
     yum -y install ohpc-gnu9-mpich-parallel-libs
     yum -y install ohpc-gnu9-openmpi4-parallel-libs
fi
if [[ ${enable_ib} -eq 1 ]];then
     yum -y install ohpc-gnu9-mvapich2-parallel-libs
fi
if [[ ${enable_opa} -eq 1 ]];then
     yum -y install ohpc-gnu9-mvapich2-parallel-libs
fi

# ----------------------------------------
# Install Intel oneAPI tools (Section 4.7)
# ----------------------------------------
if [[ ${enable_intel_packages} -eq 1 ]];then
     yum -y install intel-oneapi-toolkit-release-ohpc
     rpm --import https://yum.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB
     yum -y install intel-compilers-devel-ohpc
     yum -y install intel-mpi-devel-ohpc
     if [[ ${enable_opa} -eq 1 ]];then
          yum -y install mvapich2-psm2-intel-ohpc
     fi
     yum -y install ohpc-intel-serial-libs
     yum -y install ohpc-intel-geopm
     yum -y install ohpc-intel-io-libs
     yum -y install ohpc-intel-perf-tools
     yum -y install ohpc-intel-python3-libs
     yum -y install ohpc-intel-mpich-parallel-libs
     yum -y install ohpc-intel-mvapich2-parallel-libs
     yum -y install ohpc-intel-openmpi4-parallel-libs
     yum -y install ohpc-intel-impi-parallel-libs
fi

# -------------------------------------------------------------
# Allow for optional sleep to wait for provisioning to complete
# -------------------------------------------------------------
sleep ${provision_wait}

# ------------------------------------
# Resource Manager Startup (Section 5)
# ------------------------------------
systemctl enable munge
systemctl enable slurmctld
systemctl start munge
systemctl start slurmctld
wwsh ssh compute-* service slurmd restart

useradd -m test
wwsh file resync passwd shadow group
sleep 2
wwsh ssh compute-* /warewulf/bin/wwgetfiles
