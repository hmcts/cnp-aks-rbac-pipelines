#!/usr/bin/env bash
REV=${BUILD_BUILDNUMBER}

VSTS_COMMAND="vso[build.updatebuildnumber]"
DATE=$(date "+%Y-%m-%d")
echo "##${VSTS_COMMAND} PR-${SYSTEM_PULLREQUEST_PULLREQUESTNUMBER} ${DATE}${REV}"
