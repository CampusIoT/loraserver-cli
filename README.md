# CLI for the LoRa App Server



## Bulk loading of gateways and devices
```bash
USERNAME=bar
PASSWORD=foo
ORG=1

JWT=$(./get_jwt $USERNAME $PASSWORD)

APP_NAME="FTD"
DEV_PROFILE_NAME="FTD"
./load_devices.sh $JWT $APP_NAME $DEV_PROFILE_NAME devices.csv
./list_devices.sh $JWT $APP_NAME $DEV_PROFILE_NAME

GWPROFILE=STANDARD
./load_gateways.sh $JWT $ORG $GW_PROFILE gateways.csv
./list_gateways.sh $JWT $ORG $GW_PROFILE

Example of gateways.csv
```bash
name,description,gwid,latitude,longitude,altitude
```

Example of devices.csv
```bash
name,description,deveui,appkey
```

## Useful utilities
* https://www.npmjs.com/package/csvtojson
* https://www.npmjs.com/package/jsontocsv

```bash
sudo npm install -g csvtojson
csvtojson --help
sudo npm install -g jsontocsv
jsontocsv --help
```


## @Deprecated: Generate the bash client and HTML doc with Swagger CodeGen
Deprecated since the generated client had several times the same function for operations with the same name (ie list, delete, ...)
```bash
./generate.sh
```
