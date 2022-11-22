## Guide to Automated OpenHPC Install

[C] is your cluster number. For example, if you are configuring cluster 10, replace [C] with 10. 

1. Connect to your master node:

```
ssh root@hpcc-cluster-[C].stanford.edu
```

2. Retrieve the recipe script:
```
wget https://raw.githubusercontent.com/stanfordhpccenter/OpenHPC/main/hpc-for-the-rest-of-us/recipes/rocky8/warewulf4/slurm/recipe.sh
```


3. Run the local installation, which will take a while (> 24 minutes):
```
nohup sh recipe.sh &
```

Tail nohup.out to view progress

```
tail -f nohup.out
```

4. To verify that the compute nodes have booted, you can ping their hostname, i.e:
```ping compute-1-1```

The output should resemble this:
```
PING compute-1-12.localdomain (10.1.12.2) 56(84) bytes of data.
64 bytes from compute-1-1.localdomain (10.1.12.2): icmp_seq=1 ttl=64 time=0.244 ms
64 bytes from compute-1-1.localdomain (10.1.12.2): icmp_seq=2 ttl=64 time=0.257 ms
64 bytes from compute-1-1.localdomain (10.1.12.2): icmp_seq=3 ttl=64 time=0.253 ms
```

5. Verify that Slurm is working
```
sinfo
```

The output should resemble this
```
PARTITION AVAIL  TIMELIMIT  NODES  STATE NODELIST
normal*      up 1-00:00:00      1   idle compute-1-1
```

Interested in a live cluster building workshop using the scripts in this repository? We host "HPC for the rest of us" every two weeks, Thursday 11am Pacific, details here:

https://www.meetup.com/hpcclusters/
