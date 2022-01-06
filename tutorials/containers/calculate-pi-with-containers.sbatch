#!/bin/bash
#SBATCH --job-name=calculate-pi-with-containers
#SBATCH --output=pi_%A_%a.out
#SBATCH --error=pi_%A_%a.err
#SBATCH --ntasks=1

# load singularity
ml singularity
# run the pi estimator within our container
singularity exec julia.img julia calc_pi.jl
