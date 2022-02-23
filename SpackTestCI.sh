#!/bin/bash

# This script tests the AMReX smoke test in Spack. If a Spack directory
# does not exist, it will clone one from GitHub. Then it will install
# the latest development version of Amrex and run the Spack smoke test.
# Afterwards it will remove the test results, and uninstall only AMReX. 
# Leaving the dependencies installed will speed up subsequent runs.
# 
# There is another script SpackTestCI_SpackUpdate.sh that can be 
# run periodically so that this test will use the latest Spack 
# development branch.
#
# Erik Palmer 
# <epalmer@lbl.gov>



DIR_DATE="$(date +"%Y_%m_%d")"

# If test directory exists, append num to end
TEST_DIR=$DIR_DATE
if [ -d $TEST_DIR ]
then
    i=0
    while [ -d $TEST_DIR ]
    do
        let i++
        APPEND_NUM=`printf "%03d" $i`
        TEST_DIR=${DIR_DATE}_${APPEND_NUM}
    done
fi
mkdir $TEST_DIR


# log output and errors
exec 1>${TEST_DIR}/SpackTestCI.out 2>${TEST_DIR}/SpackTestCI.err

echo "Regression test for AMReX Spack smoke test."
START_TIME=$(date +%s.%N)


if [ ! -d "./spack" ]
then
    git clone https://github.com/spack/spack.git
fi

# Initates the Spack shell wrapper
cd spack
. ./share/spack/setup-env.sh
cd ..
spack install amrex@develop
spack test run --alias amrex_smoke_test amrex
spack test results -l amrex_smoke_test

# Don't trust the Spack pass/fail, instead
# search the output ourselves.
if (spack test results -l amrex_smoke_test | grep -q "finalized")
then
    RESULT="PASSED"
else
    RESULT="FAILED"
fi

# Clean up all spack tests.
spack test remove --yes-to-all
# Remove amrex but leave other packages to speed up next test.
spack uninstall --yes-to-all amrex


RUN_TIME=`printf "%.2f seconds" $(echo "$(date +%s.%N) - $START_TIME" | bc)`

echo "Test Result: $RESULT"
echo "Runtime: $RUN_TIME"

echo "$RESULT">"${TEST_DIR}/SpackTestCI.status"
