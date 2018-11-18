# CLI for the LoRa App Server

## Generate the bash client and HTML doc with Swagger CodeGen
```bash
./generate.sh
```

## Gateways and Endpoints Bulk Loading

```bash
USERNAME=bar
PASSWORD=foo
ORG=1

JWT=$(./get_jwt $USERNAME $PASSWORD)

GWPROFILE=STANDARD
./load_gw.sh gateways.csv  $JWT $ORG $GWPROFILE

APP=FIELD_TEST_DEVICE
./load_ep.sh endpoints.csv $JWT $ORG $APP
```
