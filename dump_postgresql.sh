#!/bin/bash

#Variaveis do script
DATA=$(date +%d-%m-%Y)
DSTDIR="../dump_postgresql_container/backups"
PJTDIR="../project"
DCKR=banco
DBNAME=dbproject
DBUSER=userproject
DBPASS=EH3zdg3eVX2NfZqCS7n98psZTey5YDQ
ARQ=backup_bd_$DBNAME-$DATA.sql
ARQCOMP=backup_bd_$DBNAME-$DATA.tar.bz2

#Função para habilitar o registro de logs
fun_log(){

	Logfile=logs/dump_postgresql.log

	dia=$(date +%d)

	#Verifica data da execução para arquivar o arquivo de log existente
	if [ $dia = 01 ]; then

		#Renomeia e comprime o arquivo de log anterior
		mv $Logfile $Logfile.2
		gzip -f $Logfile.2

		# Habilita log copiando a saÃ­da padrÃ£o para o arquivo Logfile com data e hora
		exec 1> >(while read -r line; do echo "$(date '+%d-%m-%Y   %T')   $line" | tee -a $Logfile; done)
		# faz o mesmo para a saÃ­da de ERROS
		exec 2> >(while read -r line; do echo "$(date '+%d-%m-%Y   %T')   $line" | tee -a $Logfile; done >&2)

	elif [ $dia = 11 ]; then

		#Renomeia e comprime o arquivo de log anterior
		mv $Logfile $Logfile.0
		gzip -f $Logfile.0

		# Habilita log copiando a saÃ­da padrÃ£o para o arquivo Logfile com data e hora
		exec 1> >(while read -r line; do echo "$(date '+%d-%m-%Y   %T')   $line" | tee -a $Logfile; done)
		# faz o mesmo para a saÃ­da de ERROS
		exec 2> >(while read -r line; do echo "$(date '+%d-%m-%Y   %T')   $line" | tee -a $Logfile; done >&2)

	elif [ $dia = 21 ]; then

		#Renomeia e comprime o arquivo de log anterior
		mv $Logfile $Logfile.1
		gzip -f $Logfile.1

		# Habilita log copiando a saÃ­da padrÃ£o para o arquivo Logfile com data e hora
		exec 1> >(while read -r line; do echo "$(date '+%d-%m-%Y   %T')   $line" | tee -a $Logfile; done)
		# faz o mesmo para a saÃ­da de ERROS
		exec 2> >(while read -r line; do echo "$(date '+%d-%m-%Y   %T')   $line" | tee -a $Logfile; done >&2)
	
	else

		# Habilita log copiando a saÃ­da padrÃ£o para o arquivo Logfile com data e hora
		exec 1> >(while read -r line; do echo "$(date '+%d-%m-%Y   %T')   $line" | tee -a $Logfile; done)
		# faz o mesmo para a saÃ­da de ERROS
		exec 2> >(while read -r line; do echo "$(date '+%d-%m-%Y   %T')   $line" | tee -a $Logfile; done >&2)

	fi

}

#Ativa o log do script
fun_log

echo -e "\n-Inicio do Backup-"

echo "Executando o dump no banco"
cd $PJTDIR
/usr/local/bin/docker-compose exec -T $DCKR pg_dumpall -h localhost -U $DBUSER > $DSTDIR/$ARQ

echo "Compactação"
cd $DSTDIR
tar -jacf $ARQCOMP $ARQ

echo "Apagando arquivos temporários"
rm -f $ARQ

echo "Limpeza de arquivos muito antigos"
find *.bz2 -mtime +7 -exec rm '{}' \; #Apaga arquivos com determinado tempo de criação, até 7 dias.

echo -e "-Fim do Backup postgresql -\n"
