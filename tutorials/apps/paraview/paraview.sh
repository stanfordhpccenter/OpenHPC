#!/bin/bash

mkdir -p /opt/ohpc/pub/apps/paraview/src && cd /opt/ohpc/pub/apps/paraview/src

wget https://www.paraview.org/files/v5.10/ParaView-5.10.0-osmesa-MPI-Linux-Python3.9-x86_64.tar.gz

tar -zxvf ParaView-5.10.0-osmesa-MPI-Linux-Python3.9-x86_64.tar.gz -C /opt/ohpc/pub/apps/paraview/

mkdir -p /opt/ohpc/pub/modulefiles/apps/paraview && cd /opt/ohpc/pub/modulefiles/apps/paraview

cat > 5.10.0-osmesa-MPI-Linux-Python3.9 << EOL
#%Module1.0#####################################################################

prepend-path PATH /opt/ohpc/pub/apps/paraview/ParaView-5.10.0-osmesa-MPI-Linux-Python3.9-x86_64/bin
prepend-path LD_LIBRARY_PATH /opt/ohpc/pub/apps/paraview/ParaView-5.10.0-osmesa-MPI-Linux-Python3.9-x86_64/lib
EOL

cat > /opt/ohpc/pub/examples/slurm/paraview.slurm << EOL
#!/bin/bash

#SBATCH -J paraview-server
#SBATCH -o paraview.%j.out

# Launch Paraview Server

module purge
ml apps/paraview/5.10.0-osmesa-MPI-Linux-Python3.9
mpiexec pvserver
EOL

### The following items are integrated in recipe.sh for warewulf and warewulf4
# yum --installroot=$CHROOT install mesa-libGLU

# wwvnfs --chroot=$CHROOT

# ipmitool -E -I lanplus -H 10.2.2.2 -U USERID -P PASSW0RD chassis power reset

# PASSWD=password
# echo $PASSWD | passwd --stdin test
