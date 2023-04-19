Using Paraview

Retrieve the paraview installation script:

```
wget https://raw.githubusercontent.com/stanfordhpccenter/OpenHPC/main/tutorials/apps/paraview/paraview.sh
```

Run the local installation, which will take a few minutes (> 1 minute):

```
sh ./paraview.sh
```

Change to the 'test' user:

```
su - test
```

Load the paraview module:

```
ml apps/paraview/5.10.0-osmesa-MPI-Linux-Python3.9
```

Copy the paraview.slurm script to your home directory:

```
cp /opt/ohpc/pub/examples/slurm/paraview.slurm .
```

Submit the paraview.slurm script for execution

```
sbatch paraview.slurm
```

Check the slurm output file for node name and port assigned:

```
cat paraview.[job_id].out
```

Output may resemble this:

```
Waiting for client...
Connection URL: cs://compute-1-1:11111
Accepting connection(s): compute-1-1:11111
```

In a new terminal:

```
ssh -L 11111:localhost:11111 test@hpcc-cluster-[n] -t ssh -L 11111:localhost:11111 compute-1-1
```

Connect from your client (laptop/desktop)
(client version number needs to match server version number)

Launch Paraview on your local computer, Select "connect" and enter the following for server:

```
Name: localhost_tunnel
Server Type: Client / Server
Host: localhost
Port: 11111
```

Test (from paraview tutorial on help menu)

Simple
On menu bar: Sources >> Cylinder

Select “Apply” in the properties section

Not-so-simple
File >> Open >> Examples >> disk_out_ref.ex2 >> Ok

Check all in Properties:Variables

Select “Apply” in the properties section


