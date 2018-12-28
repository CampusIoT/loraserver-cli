#!/bin/bash

# Copyright (C) CampusIoT,  - All Rights Reserved
# Written by CampusIoT Dev Team, 2016-2018

# ------------------------------------------------
# Add new devices in an application
# ------------------------------------------------

# Parameters
if [[ $# -ne 1 ]] ; then
    echo "Usage: $0 JWT"
    exit 1
fi

TOKEN="$1"


AUTH="Grpc-Metadata-Authorization: Bearer $TOKEN"
#sudo npm install -g jwt-cli
#jwt $TOKEN

# Installation
if ! [ -x "$(command -v jq)" ]; then
  echo 'jq is not installed. Installing jq ...'
  sudo apt-get install -y jq
fi

if ! [ -x "$(command -v curl)" ]; then
  echo 'curl is not installed. Installing curl ...'
  sudo apt-get install -y curl
fi

# Content-Type
ACCEPT_JSON="Accept: application/json"
ACCEPT_CSV="Accept: text/csv"
CONTENT_JSON="Content-Type: application/json"
CONTENT_CSV="Content-Type: text/csv"

# LOCAL
#PORT=8888
#URL=http://localhost:$PORT

# PROD
PORT=443
URL=https://lora.campusiot.imag.fr:$PORT

# Operations
#CURL="curl --verbose"
#CURL="curl --verbose --insecure"
CURL="curl -s --insecure"
GET="${CURL} -X GET --header \""$ACCEPT_JSON"\""
POST="${CURL} -X POST --header \""$ACCEPT_JSON"\""
PUT="${CURL} -X PUT --header \""$ACCEPT_JSON"\""
DELETE="${CURL} -X DELETE --header \""$ACCEPT_JSON"\""
OPTIONS="${CURL} -X OPTIONS --header \""$ACCEPT_JSON"\""
HEAD="${CURL} -X HEAD --header \""$ACCEPT_JSON"\""

# https://stedolan.github.io/jq/manual/

${GET} --header "$AUTH" --header "$CONTENT_JSON"  ${URL}/api/applications?limit=9999 > .applications.json
APPIDS=$(jq '.result[] | (.id | tonumber)' .applications.json)
#APPIDS=$(jq '[.result[] | .id | tonumber]' .applications.json)

#for APPID in $APPIDS
#do
#  APP_${APPID}=
#  ${GET} --header "$AUTH" --header "$CONTENT_JSON"  "${URL}/api/devices?limit=9999&applicationID=$APPID" > .devices.json
#  jq '.result[] | {deveui: .devEUI, name: .name, appid: .applicationID, lastSeenAt: .lastSeenAt}' .devices.json
#done

echo "============================"
echo "Devices"
echo "----------------------------"
${GET} --header "$AUTH" --header "$CONTENT_JSON"  "${URL}/api/devices?limit=9999" > .devices.json
jq '[.result[] | {deveui: .devEUI, name: .name, appid: .applicationID, lastSeenAt: .lastSeenAt}] | .[] | .deveui + ": " + .appid + " " + (.name | tostring) + " " + .lastSeenAt' .devices.json

echo "============================"
echo "Gateways"
echo "----------------------------"
${GET} --header "$AUTH" --header "$CONTENT_JSON"  "${URL}/api/gateways?limit=9999" > .gateways.json
jq '[.result[] | {id: .id, name: .name, description: .description, organizationID: .organizationID}] | .[] | .id + ": " + .name + " " + (.descripttion | tostring) + " " + .organizationID' .gateways.json
