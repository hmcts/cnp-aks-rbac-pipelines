#!/usr/bin/env bash
REV=${1}

VSTS_COMMAND="vso[build.updatebuildnumber]"
DATE=$(date "+%Y-%m-%d")
echo "##${VSTS_COMMAND} PR-${SYSTEM_PULLREQUEST_PULLREQUESTID} ${DATE}${REV}"
