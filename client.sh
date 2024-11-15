#!/bin/bash

PORT="2022"

echo "Cliente de Dragon Magia Abuelita Miedo 2022"

echo "1. ENVIO DE CABECERA"
echo "DMAM" | nc 127.0.0.1 $PORT

DATA=`nc -l $PORT`

echo "3. COMPROBANDO HEADER"
if [ "$DATA" != "OK_HEADER" ]
then
	echo "ERROR 1: El header se envio incorrectamente"
	exit 1
fi

echo "4. CHECK OK - Enviando el FILE_NAME"
FILE_NAME="dragon.txt"
echo "FILE_NAME $FILE_NAME" | nc 127.0.0.1 $PORT

DATA=`nc -l $PORT`

echo "7. COMPROBANDO FILE_NAME"
if [ "$DATA" != "OK_FILE_NAME" ]
then
	echo "ERROR 2: El filename se envio incorrectamente"
	exit 2
fi

echo "8. CHEK OK - Filename recibido correctamente"
