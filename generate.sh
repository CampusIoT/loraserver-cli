#!/bin/bash

SWAGGER_DOC=https://lora.campusiot.imag.fr/swagger/api.swagger.json
wget $SWAGGER_DOC --no-check-certificate

wget http://central.maven.org/maven2/io/swagger/swagger-codegen-cli/2.3.1/swagger-codegen-cli-2.3.1.jar -O swagger-codegen-cli.jar

sudo apt-get update
sudo apt-get install default-jre

java -jar swagger-codegen-cli.jar help
java -jar swagger-codegen-cli.jar langs

java -jar swagger-codegen-cli.jar generate -i api.swagger.json  -l html2 -o html2
# (cd html2; open index.html)

# java -jar swagger-codegen-cli.jar generate -i api.swagger.json  -l javascript -o javascript
# (cd javascript; npm install)

java -jar swagger-codegen-cli.jar generate -i api.swagger.json  -l bash -o bash

cd bash/
chmod +x client.sh
./client.sh --help
./client.sh --about
./client.sh --insecure --host https://lora.campusiot.imag.fr/api list --help
