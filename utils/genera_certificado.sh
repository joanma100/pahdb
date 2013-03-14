#!/bin/bash
#
# Genera un certificado autofirmado
#
#USUARIO="www-data:www-data"
#DESTINO="/var/www/pahdb/ssl"

if [[ $# -ne 2 ]]; then
	echo "USO: genera_certificado.sh <USUARIO:GRUPO> <DESTINO>"
	exit 1
fi

USUARIO=$1
DESTINO=$2

# Si el directorio DESTINO no existe lo creamos y nos movemos allí
if [[ ! -d $DESTINO ]]; then
	mkdir -p $DESTINO
	chown "$USUARIO" $DESTINO
fi
cd $DESTINO

# Generamos la clave privada protegida con contraseña: pahdb-passwd.key
openssl genrsa -des3 -out pahdb-passwd.key 4096

# Generamos la solicitud de firma de certificado (CSR)
openssl req -new -key pahdb-passwd.key -out pahdb.csr

# Generamos la clave privada sin contraseña: pahdb.key
openssl rsa -in pahdb-passwd.key -out pahdb.key

# Generamos la clave pública autofirmada (CRT)
openssl x509 -req -days 365 -in pahdb.csr -signkey pahdb.key -out pahdb.crt

# Borramos pahdb-passwd.key y pahdb.csr
rm pahdb-passwd.key pahdb.csr

# Ajustamos los permisos
chown "$USUARIO" pahdb.key pahdb.crt
chmod 400 pahdb.key pahdb.crt


