#!/usr/bin/env bash

END=99

# Expand files into a temporary directory
mkdir ./jobs
for i in $(seq 0 $END)
do
  cat job-template.yaml | sed "s/\$ITEM/$i/" > ./jobs/job-$i.yaml
done