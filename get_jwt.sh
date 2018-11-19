#!/bin/bash

# Copyright (C) CampusIoT,  - All Rights Reserved
# Written by CampusIoT Dev Team, 2016-2018

# Parameters
if [[ $# -ne 2 ]] ; then
    echo "Usage: $0 USERNAME PASSWORD"
    exit 1
fi
USERNAME=$1
PASSWORD=$2

# Installation
if ! [ -x "$(command -v jq)" ]; then
  >&2 echo 'jq is not installed. Installing jq ...'
  sudo apt-get install -y jq
fi

if ! [ -x "$(command -v curl)" ]; then
  >&2 echo 'curl is not installed. Installing curl ...'
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

# Doc
URL_SWAGGER=${URL}/swagger/api.swagger.json

# Operations
# CURL="curl --verbose"
#CURL="curl -k --verbose --insecure"
CURL="curl -k --insecure"
GET="${CURL} -X GET --header \""$ACCEPT_JSON"\""
POST="${CURL} -X POST --header \""$ACCEPT_JSON"\""
PUT="${CURL} -X PUT --header \""$ACCEPT_JSON"\""
DELETE="${CURL} -X DELETE --header \""$ACCEPT_JSON"\""
OPTIONS="${CURL} -X OPTIONS --header \""$ACCEPT_JSON"\""
HEAD="${CURL} -X HEAD --header \""$ACCEPT_JSON"\""

# ===================================
# Get OpenAPI2.0 specification of the XNet API
# -----------------------------------
#${GET} ${URL_SWAGGER} > api.swagger.json

# ===================================
# Authenfication operations
# -----------------------------------
# 0 for admin
# 5 for demo
# 9999 for devteam
# 10000 for loadinjection


AUTH_JSON="{ \"username\": \"${USERNAME}\", \"password\": \"${PASSWORD}\" }"

# Get the Bearer token for the user
rm $USERNAME.token.json
${POST}  --header "$CONTENT_JSON" -d "$AUTH_JSON" ${URL}/api/internal/login > $USERNAME.token.json
TOKEN=$(jq -r '.jwt' $USERNAME.token.json)
AUTH="Grpc-Metadata-Authorization: Bearer $TOKEN"
echo "$TOKEN"
