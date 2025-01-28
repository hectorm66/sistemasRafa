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
PREFIX=$(echo "$DATA" | cut -d ' ' -f 1)
FILE_NAME=$(echo "$DATA" | cut -d ' ' -f 2)
RECEIVED_MD5=$(echo "$DATA" | cut -d ' ' -f 3)

if [ "$PREFIX" != "FILE_NAME" ]
then
	echo "ERROR 2: Prefijo incorrecto"
	echo "KO_FILE_NAME" | nc localhost $PORT
	exit 2
fi

CALCULATED_MD5=$(echo -n "$FILE_NAME" | md5sum | awk '{print $1}')
if [ "$CALCULATED_MD5" != "$RECEIVED_MD5" ]
then
	echo "ERROR 2: MD5 del nombre de archivo incorrecto"
	echo "KO_FILE_NAME_MD5" | nc localhost $PORT
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
	echo "ERROR 3. Contenido incorrecto"
	echo "KO_DATA" | nc localhost $PORT
	exit 3
fi

echo "OK_DATA" | nc localhost $PORT


echo "14. Escuchando FILE_MD5"
DATA=$(nc -l $PORT)
PREFIX=$(echo "$DATA" | cut -d ' ' -f 1)
MD5_RECEIVED=$(echo "$DATA" | cut -d ' ' -f 2)

if [ "$PREFIX" != "FILE_MD5" ]; then
    echo "KO_FILE_MD5" | nc localhost $PORT
    echo "ERROR 4: Prefijo FILE_MD5 incorrecto"
    exit 4
fi
echo "15. Prefijo FILE_MD5 validado correctamente"

MD5_GENERATED=$(md5sum server/$FILE_NAME | cut -d ' ' -f 1)

echo "16. MD5 generado: $MD5_GENERATED, MD5 recibido: $MD5_RECEIVED"

if [ "$MD5_GENERATED" != "$MD5_RECEIVED" ]; then
    echo "KO_FILE_MD5" | nc localhost $PORT
    echo "ERROR 5: El hash MD5 no coincide"
    exit 5
fi
echo "OK_FILE_MD5" | nc localhost $PORT
echo "17. Hash MD5 validado correctamente"
