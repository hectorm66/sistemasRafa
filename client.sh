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
FILE_NAME_MD5=$(echo -n "$FILE_NAME" | md5sum | awk '{print $1}')
echo "FILE_NAME $FILE_NAME $FILE_NAME_MD5" | nc 127.0.0.1 $PORT

DATA=`nc -l $PORT`

echo "7. COMPROBANDO FILE_NAME"
if [ "$DATA" != "OK_FILE_NAME" ]
then
	if ["$DATA" != "OK_FILE_NAME" ]
	then
		echo "ERROR 2: El MD5 del nombre de archivo es incorrecto"
	else
		echo "ERROR 2: El filename se envió incorrectamente"
	fi
	exit 2
fi

echo "8. CHEK OK - Enviando archivo"
cat client/$FILE_NAME | nc localhost $PORT

DATA=`nc -l $PORT`

echo "11. COMPROBACION DATA"
if [ "$DATA" != "OK_DATA" ]
then
	echo "ERROR 3: El contenido se envio incorrectamente"
	exit 3
fi

echo "12. CHECK OK - Datos enviados correctamente"


MD5SUM=$(md5sum client/$FILE_NAME | cut -d ' ' -f 1)
echo "FILE_MD5 $MD5SUM" | nc localhost $PORT
echo "13. Enviando FILE_MD5"


DATA=$(nc -l $PORT)
if [ "$DATA" != "OK_FILE_MD5" ]; then
    echo "ERROR 4: La validación del hash MD5 falló"
    exit 4
fi
echo "18. Validación correcta del hash MD5"




