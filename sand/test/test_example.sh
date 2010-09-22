#!/bin/bash

port=9091

PATH=../src:../../dttools/src:$PATH
export PATH

error_state=0;

echo "Compressing reads"
sand_compress_reads < test_20.fa > test_20.cfa

echo "Starting worker for filtering"
worker -t 5s -d all -o worker.log localhost $port &
wpid=$!
echo "Worker is process $wpid"

echo "Starting filter master"
ln -s `which sand_filter_mer_seq` .
sand_filter_master -s 10 -p $port -b test_20.cfa test_20.cand -d all -o filter.log || { echo "Error in filtering."; kill -9 $wpid; exit 1 ; }

echo "Starting Smith-Waterman assembly..."
ln -s `which sand_sw_alignment` .
sand_align_master -n 1 -p $port sand_sw_alignment test_20.cand test_20.cfa test_20.ovl -d all -o sw.log || { echo "Error in alignment."; kill -9 $wpid; exit 1 ; }

echo "Checking assembly results"
diff --brief test_20.ovl test_20.right && echo "Files test_20.ovl and test_20.right are the same" || { kill -9 $wpid ; exit 1 ; }

echo "Waiting for worker to exit"
wait $wpid

exit 0;
