#!/bin/bash -x


DIR_DATE="$(date +"%Y-%m-%d")"

# If directory exists append num to end
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


exec 3>&1 4>&2
exec 1>SpackTestCI.out 2>SpackTestCI.err

echo "Regression test for AMReX Spack smoke test."

start_time=$(date +%s.%N)


if [ ! -d "./spack" ]
then
    git clone https://github.com/spack/spack.git
fi

cd spack

. ./share/spack/setup-env.sh

spack install amrex@develop

spack test run --alias amrex_smoke_test amrex

if [ grep -q $(spack test results -l amrex_smoke_test) "finalized" ]
then
    result="PASSED"
else
    result="FAILED"
fi

run_time=`printf "%.2f seconds" $(echo "$(date +%s.%N) - $start_time" | bc)`



echo "Runtime: $run_time"

exec 1>SpackTestCI.status

echo "Status"
