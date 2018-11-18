# CLI for the LoRa App Server

## Generate the bash client and HTML doc with Swagger CodeGen
```bash
./generate.sh
```

## Gateways and Endpoints Bulk Loading

```bash
JWT=$(./get_jwt $USERNAME $PASSWORD)
./load_gw.sh gateways.csv  $JWT $ORG  $GWPROFILE
./load_ep.sh endpoints.csv $JWT $ORG $APP
```
