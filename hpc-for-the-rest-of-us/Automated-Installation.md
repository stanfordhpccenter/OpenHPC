## Guide to Automated OpenHPC Install

[C] is your cluster number. For example, if you are configuring cluster 10, replace [C] with 10. 

1. Connect to your master node:

```
ssh root@hpcc-cluster-[C].stanford.edu
```

2. Open /etc/hosts and prepend the following:
```
10.1.1.1  hpcc-cluster-[C].cluster hpcc-cluster-[C]
```

3. Retrieve the recipe script:
```
https://raw.githubusercontent.com/stanfordhpccenter/OpenHPC/main/hpc-for-the-rest-of-us/recipes/rocky8/warewulf/slurm/recipe.sh
```

4. Retrieve the input.local file:
```
https://raw.githubusercontent.com/stanfordhpccenter/OpenHPC/main/hpc-for-the-rest-of-us/recipes/rocky8/warewulf/slurm/input.local
```

5. Revise the input file to suit your cluster settings. If your cluster is hpcc-cluster-1, the following would be correct:

```
sms_name="${sms_name:-hpcc-cluster-1}"
```
Uncomment hardware address for compute node on your cluster number:

```
# hpcc-cluster-1
c_mac[0]=40:F2:E9:02:48:B8
```

6. Open access to the installation file:
```
chmod u+r+x recipe.sh
```

7. Run the local installation, which will take a while (> 20 minutes). Alternatively, you can use nohup to ensure the installation doesn't terminate if your session accidentally ends ```nohup ./recipe.sh &```:
```
nohup ./recipe.sh &
```

Tail nohup.out to view progress

```
tail -f nohup.out
```

8. To verify that the compute nodes have booted, you can ping their hostname, i.e:
```ping compute-1-1```

The output should resemble this:
```
PING compute-1-12.localdomain (10.1.12.2) 56(84) bytes of data.
64 bytes from compute-1-1.localdomain (10.1.12.2): icmp_seq=1 ttl=64 time=0.244 ms
64 bytes from compute-1-1.localdomain (10.1.12.2): icmp_seq=2 ttl=64 time=0.257 ms
64 bytes from compute-1-1.localdomain (10.1.12.2): icmp_seq=3 ttl=64 time=0.253 ms
```

9. Verify that Slurm is working
```
sinfo
```

The output should resemble this
```
PARTITION AVAIL  TIMELIMIT  NODES  STATE NODELIST
normal*      up 1-00:00:00      1   idle compute-1-1
```
