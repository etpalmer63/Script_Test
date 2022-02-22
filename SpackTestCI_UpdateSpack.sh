#!/bin/bash set -e


exec 1>UpdateSpack.out 2>UpdateSpack.err

echo "Update Spack."

#start_time=$(date +%s.%N) 


if [ ! -d "./spack" ]
then
    echo "Cannot find spack directory!"
    exit 1
fi

rm -rf spack
git clone https://github.com/spack/spack.git
cd spack


#run_time=`printf "%.2f seconds" $(echo "$(date +%s.%N) - $start_time" | bc)`

#echo "Runtime: $run_time"


