#!/bin/bash

# Copyright (C) CampusIoT,  - All Rights Reserved
# Written by CampusIoT Dev Team, 2016-2018

# ------------------------------------------------
# Add new users in an organization
# ------------------------------------------------

# Parameters
if [[ $# -ne 3 ]] ; then
    echo "Usage: $0 JWT ORGID CSVFILE"
    exit 1
fi

TOKEN="$1"
ORGID="$2"
CSVFILE="$3"

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

OLDIFS=$IFS
IFS=","
while read USERNAME PASSWORD EMAIL ISADMIN NOTE
 do
   echo; echo Create user: $USERNAME $PASSWORD $EMAIL $ISADMIN $NOTE
   echo '{"organizations":[{"isAdmin":'$ISADMIN',"organizationID":"'$ORGID'"}],"password":"'$PASSWORD'","user":{"username":"'$USERNAME'","email":"'$EMAIL'","note":"'$NOTE'","password":"'$PASSWORD'","isAdmin":'$ISADMIN',"isActive":true}}' > .user-$USERNAME.json
   curl -s --insecure --data "@.user-$USERNAME.json" --header "$AUTH" --header "$CONTENT_JSON"  "${URL}/api/users"

   # TODO send email to $EMAIL
 done < $CSVFILE
IFS=$OLDIFS

echo;
