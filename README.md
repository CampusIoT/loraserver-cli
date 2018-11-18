# CLI for the LoRa App Server



## Bulk loading of gateways and devices 
```bash
USERNAME=bar
PASSWORD=foo
ORG=1

JWT=$(./get_jwt $USERNAME $PASSWORD)

GWPROFILE=STANDARD
./load_gw.sh gateways.csv  $JWT $ORG $GWPROFILE

APP=FIELD_TEST_DEVICE
./load_ep.sh devices.csv $JWT $ORG $APP
```

Example of gateways.csv
```bash
name,TODO
```

Example of devices.csv
```bash
name,deveui,appkey,TODO
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
