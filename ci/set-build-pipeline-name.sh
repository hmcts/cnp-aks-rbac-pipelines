#!/usr/bin/env bash
VSTS_COMMAND="vso[build.updatebuildnumber]"
DATE=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
echo "##${VSTS_COMMAND} PR-${SYSTEM_PULLREQUEST_PULLREQUESTNUMBER} ${DATE}"
