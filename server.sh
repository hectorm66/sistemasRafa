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
FILE_NAME=`echo "$DATA" | cut -d ' ' -f 2`

if [ "$PREFIX" != "FILE_NAME" ]
then
	echo "ERROR 2: Prefijo incorrecto"
	echo "KO_FILE_NAME" | nc localhost $PORT
	exit 2
fi

echo "6. CHECK OK - Enviando OK_FILENAME"
echo "OK_FILE_NAME" | nc localhost $PORT

DATA=`nc -l $PORT`

echo "9. RECIBIENDO Y ALMACENANDO DATOS"
echo "$DATA" > server/$FILE_NAME

echo "10. COMPROBANDO DATA Y RESPUESTA"
DRAGON=`cat /home/enti/projects/sistemasRafa/server/dragon.txt`
if [ "$DATA" != "$DRAGON" ]
then
	echo "ERROR 3."
	echo "KO_DATA"
	exit 3
fi
echo "OK_DATA" | nc localhost $PORT
cat server/$FILE_NAME
