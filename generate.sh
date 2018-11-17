#!/bin/bash

SWAGGER_DOC=https://lora.campusiot.imag.fr/swagger/api.swagger.json
wget $SWAGGER_DOC --no-check-certificate

wget http://central.maven.org/maven2/io/swagger/swagger-codegen-cli/2.3.1/swagger-codegen-cli-2.3.1.jar -O swagger-codegen-cli.jar

java -jar swagger-codegen-cli.jar help
java -jar swagger-codegen-cli.jar langs
java -jar swagger-codegen-cli.jar generate -i api.swagger.json  -l bash -o bash
java -jar swagger-codegen-cli.jar generate -i api.swagger.json  -l html2 -o html2
# java -jar swagger-codegen-cli.jar generate -i api.swagger.json  -l javascript -o javascript
