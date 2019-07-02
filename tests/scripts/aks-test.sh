#!/bin/bash
set -e

WAITTIME=$1:0
#Sleep so that flux is able to update manifests
sleep ${WAITTIME}
export PATH="${PATH}:${HOME}/go/bin"
go test

