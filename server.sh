#!/bin/bash


PORT="2022"

echo "Servidor de Dragon Magia Abuelita Miedo 2022"

echo "0. ESCUCHAMOS"

DATA=`nc -l $PORT`

if [ "$DATA" != "DMAM" ]
then
    echo "ERROR 1: Cabecera incorrecta"
	echo "KO_HEADER" | nc localhost $PORT
	exit 1
fi

echo "2. CHECK OK - Enviando OK_HEADER"
echo "OK_HEADER" | nc localhost $PORT


DATA=`nc -l $PORT`

echo "5. COMPROBANDO FILENAME"
PREFIX=`echo "$DATA" | cut -d ' ' -f 1`

if [ "$PREFIX" != "FILE_NAME" ]
then
	echo "ERROR 2: Prefijo incorrecto"
	echo "KO_FILE_NAME" | nc localhost $PORT
	exit 2
fi

echo "6. CHECK OK - Enviando OK_FILENAME"
echo "OK_FILE_NAME" | nc localhost $PORT
