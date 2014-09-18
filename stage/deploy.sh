#!/bin/bash
#obtenemos la fecha actual
AHORA="`date +"%Y%m%d-%H%M%S"`"

#obtenemos el nombre del último release
LASTRELEASE=$(find * -type d -prune -exec ls -d {} \; |tail -1)
# creamos el folder fechado para el stage
#mkdir ./$AHORA

#clonamos del repositorio y versionamos
git clone ../repositorio $AHORA

# eliminamos el directorio .git
rm -rf ./$AHORA/.git

#eliminamos archivos excepto el theme actual
#

#comparamos si el stage es diferente al anterior
# -r recursivo -q reporta solo si hay diferencias
#diff -rq <directory1> <directory2>

#ahora con manzanas...
#ls -lR $LASTRELEASE > a.txt
#ls -lR $AHORA > b.txt
#if ! diff -q a.txt b.txt > /dev/null ; then
if ! diff -rq $LASTRELEASE $AHORA > /dev/null ; then
	#en caso de ser diferentes realizamos el deploy
	echo "Son diferentes =================================================="
	#eliminamos a y b
	#rm a.txt
	#rm b.txt

	# escribimos el archivo con la info del release
	echo "$AHORA" >> ./../rollback/$AHORA.txt

	# RSYNC al servidor de producción
	rsync -rtv -P --log-file=../rollback/$AHORA.txt ./$AHORA/ ../produccion/
else
	#en caso de ser iguales eliminamos el stage actual y el log de copia
	echo "Son iguales =================================================="
	rm -rf $AHORA
fi

echo "TERMINADO"
exit