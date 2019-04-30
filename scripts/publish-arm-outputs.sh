#!/bin/bash
INPUT_VARIABLE="${1}"
for row in $(echo "${INPUT_VARIABLE}" | jq -c '. | to_entries[]'); do
    outputName=$(echo ${row} | jq -r ".key")
    outputValue=$(echo ${row} | jq -r ".value.value")
    echo "##vso[task.setvariable variable=${outputName}]${outputValue}"
done