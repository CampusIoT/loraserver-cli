#!/bin/bash

# Copyright (C) CampusIoT,  - All Rights Reserved
# Written by CampusIoT Dev Team, 2016-2018

# ------------------------------------------------
# Add new gateways in an organization
# ------------------------------------------------

# Parameters
if [[ $# -ne 5 ]] ; then
    echo "Usage: $0 JWT ORGID NSNAME GWPROFNAME CSVFILE"
    exit 1
fi

TOKEN="$1"
ORGID="$2"
NSNAME="$3"
GWPROFNAME="$4"
CSVFILE="$5"

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

${GET} --header "$AUTH" --header "$CONTENT_JSON"  "${URL}/api/network-servers?limit=9999" > .networkservers.json
NSID=$(jq '.result[] | select(.name == "'$NSNAME'") | .id | tonumber' .networkservers.json)
#echo $NSID

${GET} --header "$AUTH" --header "$CONTENT_JSON"  "${URL}/api/gateway-profiles?limit=9999&networkServerID=$NSID" > .gateway-profiles.json
GWPROFID=$(jq '.result[] | select(.name == "'$GWPROFNAME'") | .id' .gateway-profiles.json)
#echo $GWPROFID

OLDIFS=$IFS
IFS=","
while read NAME DESCR GWID LATITUDE LONGITUDE
 do
   echo; echo Create gateway: $NAME $DESCR $GWID $LATITUDE $LONGITUDE
   echo '{"gateway":{"location":{"latitude":'$LATITUDE',"longitude":'$LONGITUDE'},"name":"'$NAME'","description":"'$DESCR'","id":"'$GWID'","gatewayProfileID":'$GWPROFID',"networkServerID":'$NSID',"discoveryEnabled":true,"organizationID":'$ORGID'}}' > .gateway-$GWID.json
   curl -s --insecure --data "@.gateway-$GWID.json" --header "$AUTH" --header "$CONTENT_JSON"  "${URL}/api/gateways"
 done < $CSVFILE
IFS=$OLDIFS

echo;

#${GET} --header "$AUTH" --header "$CONTENT_JSON"  "${URL}/api/gateways?limit=9999" > .gateways.json
#jq '.result' .gateways.json
