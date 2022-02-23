#!/bin/bash -e

# This script removes the spack folder to 
# force update the next time SpackTestCI.sh
# is run.
#
# Erik Palmer
# <epalmer@lbl.gov>

SPACK_TEST_ROOT_DIR=/home/epalmer/SpackTestRoot

pushd $SPACK_TEST_ROOT_DIR
 
    echo "Replace Spack folder."
    
    if [ ! -d "./spack" ]
    then
        echo "Cannot find spack directory!"
        exit 1
    else
        rm -rf spack
        git clone https://github.com/spack/spack.git
    fi

popd


