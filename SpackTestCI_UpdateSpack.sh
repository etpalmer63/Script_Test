#!/bin/bash set -e

# This script removes the spack folder to 

echo "Replace Spack folder."

if [ ! -d "./spack" ]
then
    echo "Cannot find spack directory!"
    exit 1
else
    rm -rf spack
    git clone https://github.com/spack/spack.git
fi



