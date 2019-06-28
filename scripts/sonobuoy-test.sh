#!/bin/bash
set -e

MODE=$1

go get -u -v github.com/heptio/sonobuoy
sonobuoy delete --wait

sonobuoy run --mode ${MODE} --wait
results=$(sonobuoy retrieve)
sonobuoy e2e $results

# unzipping results to publish as test artifacts
mkdir results && tar -xf $results -C results


sonobuoy delete --all

