#!/bin/bash

ARM_OUTPUT=$1

if [ -z "${ARM_OUTPUT}" ] ; then
  echo "JSON ARM Output is required." 
  exit 1
fi

for row in $(echo "${ARM_OUTPUT}" | jq -c '. | to_entries[]'); do
  outputName=$(echo ${row} | jq -r ".key")
  outputValue=$(echo ${row} | jq -r ".value.value")
  echo "##vso[task.setvariable variable=${outputName}]${outputValue}"
done