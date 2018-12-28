#!/bin/bash

# Copyright (C) CampusIoT,  - All Rights Reserved
# Written by CampusIoT Dev Team, 2016-2018

# ------------------------------------------------
# Add new organization
# ------------------------------------------------

# Default List of factory-preset frequencies (Hz), comma separated.
EU868_FREQS="868100000,868300000,868500000,867100000,867300000,867500000,867700000,867900000"

# Parameters
if [[ $# -ne 4 ]] ; then
    echo "Usage: $0 JWT ORGNAME DISPLAYNAME CAN_HAVE_GATEWAYS"
    exit 1
fi

TOKEN="$1"
ORGNAME="$2"
DISPLAYNAME="$3"
CAN_HAVE_GATEWAYS="$4"

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

ORGNAME="$2"
DISPLAYNAME="$3"
CAN_HAVE_GATEWAYS="$4"

echo; echo "Create organization: $ORGNAME $DISPLAYNAME; Can have gateways : $CAN_HAVE_GATEWAYS"
echo '{"organization":{"name":"'$ORGNAME'","displayName":"'$DISPLAYNAME'","canHaveGateways":'$CAN_HAVE_GATEWAYS'}}' > .org-$ORGNAME.json
curl -s --insecure "${URL}/api/organizations" \
 --header "$AUTH" --header "$CONTENT_JSON" \
 --data "@.org-$ORGNAME.json" \
 > .org.json
ORGID=$(jq '.id | tonumber' .org.json)
echo; echo "Organization ID : $ORGID"

echo; echo "Create service-profile: DEFAULT"
curl -s --insecure "${URL}/api/service-profiles" \
 --header "$AUTH" --header "$CONTENT_JSON" \
 --data '{"serviceProfile":{"name":"DEFAULT","networkServerID":"1","addGWMetaData":true,"nwkGeoLoc":true,"devStatusReqFreq":48,"reportDevStatusBattery":true,"reportDevStatusMargin":true,"drMax":5,"organizationID":"'$ORGID'"}}'


echo; echo "Create device-profile: CLASS_A_OTAA"
curl -s --insecure  'https://lora.campusiot.imag.fr/api/device-profiles' \
  --header "$AUTH" --header "$CONTENT_JSON" \
  --data '{"deviceProfile":{"name":"CLASS_A_OTAA","networkServerID":"1","macVersion":"1.0.2","regParamsRevision":"A","supportsJoin":true,"organizationID":"'$ORGID'"}}'


echo; echo "Create device-profile: CLASS_A_ABP"
curl 'https://lora.campusiot.imag.fr/api/device-profiles' \
  --header "$AUTH" --header "$CONTENT_JSON" \
  --data '{"deviceProfile":{"name":"CLASS_A_ABP","networkServerID":"1","macVersion":"1.0.2","regParamsRevision":"A","factoryPresetFreqsStr":"'$EU868_FREQS'","factoryPresetFreqs":['$EU868_FREQS'],"organizationID":"'$ORGID'"}}'

echo;
