#!/bin/bash
#SBATCH --partition=sahalabgpu
#SBATCH -J 5-equil1_test
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1
##SBATCH --exclusive
##SBATCH --exclude=execute-

source ~/Data/conda/bin/activate 
source /sharedapps/Commercial-Software/amber24/amber.sh
 
export CUDA_VISIBLE_DEVICES=5
date

#pmemd.cuda -O -i md.in -p step3_input.parm7 -c step5_10.rst7 -o md.out -r gamd-1.rst -x md-1.nc -gamd gamd-1.log
#pmemd.cuda -O -i md.in -p step3_input.parm7 -c gamd-1.rst -o md2.out -r gamd-2.rst -x md-2.nc -gamd gamd-2.log

pmemd.cuda -O -i gamd-restart.in -p step3_input.parm7 -c gamd-1.rst -o gamd-2.out -x md-2.nc -r gamd-2.rst -gamd gamd-2.log

##GaMD restart production
for ((i=3; i<=21; i++)); do
    prev=$((i-1))  # Get the previous step number

    pmemd.cuda -O -i md-restart.in -p step3_input.parm7 -c gamd-${prev}.rst -o gamd-${i}.out -x md-${i}.nc -r gamd-${i}.rst -gamd gamd-${i}.log
done
#pmemd.cuda -O -i md-restart.in -p step3_input.parm7 -c gamd-2.rst -o gamd-3.out -x md-3.nc -r gamd-3.rst -gamd gamd-3.log
