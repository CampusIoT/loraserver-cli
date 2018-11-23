# CLI for the LoRa App Server

## Bulk loading of gateways and devices
```bash
USERNAME=alice
PASSWORD=__MY_VERY_SECRET_PASSWORD__

JWT=$(./get_jwt.sh $USERNAME $PASSWORD)

APP_NAME="FTD"
DEV_PROFILE_NAME="CLASS_A_OTAA"
./add_devices.sh $JWT $APP_NAME $DEV_PROFILE_NAME devices.csv
# TBI ./list_devices.sh $JWT $APP_NAME
# TBI ./list_devices.sh $JWT

ORGID=1
NS_NAME="loraserver"
GW_PROFILE_NAME="DEFAULT"
./add_gateways.sh $JWT $ORGID $NS_NAME $GW_PROFILE_NAME gateways.csv
# TBI ./list_gateways.sh $JWT $ORGID $NS_NAME $GW_PROFILE_NAME
# TBI ./list_gateways.sh $JWT $ORGID $NS_NAME
# TBI ./list_gateways.sh $JWT $ORGID

ORGID=1
./add_users.sh $JWT $ORGID users.csv
# TBI ./list_users.sh $JWT $ORGID
# TBI ./list_users.sh $JWT
```
Example of devices.csv
```
name,description,deveui,appkey
```
Example of gateways.csv
```
name,description,gwid,latitude,longitude
```
Example of users.csv
```
username,password,email,isadmin,note
```


## Useful utilities
* https://www.npmjs.com/package/csvtojson
* https://www.npmjs.com/package/jsontocsv
* https://stedolan.github.io/jq/manual/

```bash
sudo npm install -g csvtojson
csvtojson --help
sudo npm install -g jsontocsv
jsontocsv --help
```

```bash
jq '[.[] | {"name":.name, "deveui":.deveui, "appkey":.appkey}]'  fulldevices.json > devices.json
```

### TODOLIST
* ./add_devices_abp.sh
* ./list_devices.sh
* ./list_gateways.sh
* ./list_users.sh

## @Deprecated: Generate the bash client and HTML doc with Swagger CodeGen
Deprecated since the generated client had several times the same function for operations with the same name (ie list, delete, ...)
```bash
./generate.sh
```
