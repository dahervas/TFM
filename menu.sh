#!/bin/sh


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
      echo "     *  dhervas18@alumnos.uned.es                                       *"
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
      echo "         *  dhervas18@alumnos.uned.es                                       *"
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
    echo "98) Opcion 98: Inicializar BDD"
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
        _metasploit $dom & bash spinner.sh $!
      fi
    fi

    if [ "$1" -eq "6" ]; then
        echo "Generación del reporte"
        echo "------------------------------------"
        echo ""
        _report $dom & bash spinner.sh $!
    fi

    if [ "$1" -eq "98" ]; then
      echo "Inicialización de la base de datos"
      echo "------------------------------------"
      _initBDD & bash spinner.sh $!
    fi   

    if [ "$1" -eq "99" ]; then
     #setopt shwordsplit


      sqlite3 /home/david/TFM/BDD.db 'DELETE FROM T_NMAP;'
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
            sqlite3 /home/david/TFM/BDD.db <<END_SQL
            INSERT INTO T_NMAP(PUERTO,INFO) VALUES ('$puerto','$part');
END_SQL

          done
        fi 2>/dev/null

        if [ $flag -eq 0 ]; then
          linea=$(echo $line | sed 's/^..//')
          
          sqlite3 /home/david/TFM/BDD.db <<END_SQL
            INSERT INTO T_NMAP(PUERTO,INFO) VALUES ('$puerto','$linea');
END_SQL
        fi  2>/dev/null

      done </home/david/TFM/temp/nmapLog.txt 
      sqlite3 /home/david/TFM/BDD.db 'SELECT * FROM T_NMAP';
    #xmllint --format /home/david/TFM/temp/nmap_output.xml > /home/david/TFM/temp/nmap_output.txt
    #sqlite3 /home/david/TFM/BDD.db 'INSERT INTO T_NMAP(PUERTO,INFO) VALUES ("IP",'$line');'
    #cat /home/david/TFM/temp/nmap_output.txt| tr -d "[:blank:]" > /home/david/TFM/temp/nmap_output2.txt && mv /home/david/TFM/temp/nmap_output2.txt /home/david/TFM/temp/nmap_output.txt
    #sed -n -e '/^<port/p' /home/david/TFM/temp/nmap_output.txt > /home/david/TFM/temp/port.txt
    #nmap -sV --script=vulscan/vulscan.nse --script-args vulscandb=cve.csv www.example.com > /home/david/TFM/temp/nmapLog.txt
    #sed "$(( $(wc -l </home/david/TFM/temp/nmapLog.txt)-2 )),$ d" /home/david/TFM/temp/nmapLog.txt > /home/david/TFM/temp/nmapMod.txt 
    #sed -e '1,6d' /home/david/TFM/temp/nmapMod.txt > /home/david/TFM/temp/nmapLog.txt
    #sed '/^|_/d' /home/david/TFM/temp/nmapLog.txt > /home/david/TFM/temp/nmapMod.txt
    #sed '/^| vulscan/d' /home/david/TFM/temp/nmapMod.txt > /home/david/TFM/temp/nmapLog.txt
    #sed -r '/^.{,3}$/d' /home/david/TFM/temp/nmapLog.txt > /home/david/TFM/temp/nmapMod.txt
    #sed '/closed/d' /home/david/TFM/temp/nmapMod.txt > /home/david/TFM/temp/nmapLog.txt
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
      #sqlite3 /home/david/TFM/BDD.db <<'END_SQL'
      #INSERT INTO TEST(CLAVE1, CLAVE2) VALUES ('$var',"TEST INSERCIÓN");
      #CREATE TABLE IF NOT EXISTS TEST2 AS SELECT * FROM TEST;
      #INSERT INTO TEST2 SELECT * FROM TEST;
      #DELETE FROM TEST;
      #SELECT * FROM TEST2;
      #sqlite3 /home/david/TFM/BDD.db 'INSERT INTO TEST2(CLAVE1, CLAVE2) VALUES ('$var',"TEST INSERCIÓN");' 2>/dev/null
#END_SQL
    #sed -n -e '/^<email>/p' /home/david/TFM/temp/theHarvest.txt > /home/david/TFM/temp/email.txt

    #if [ -s /home/david/TFM/temp/email.txt ]; then
      #echo "email.txt no está vacío"
      #sed -e 's!<email>!!' /home/david/TFM/temp/email.txt > /home/david/TFM/temp/email2.txt && mv /home/david/TFM/temp/email2.txt /home/david/TFM/temp/email.txt
      #sed -e 's!</email>!!' /home/david/TFM/temp/email.txt > /home/david/TFM/temp/email2.txt && mv /home/david/TFM/temp/email2.txt /home/david/TFM/temp/email.txt
      #sed -i '/^$/d' /home/david/TFM/temp/email.txt
      
      #while read p; do
        #line=$(echo "'""$p""'")
        #sqlite3 /home/david/TFM/BDD.db 'INSERT INTO T_THEHARVEST(TIPO,DOCUMENTO) VALUES ("EMAIL",'$line');'
      #done </home/david/TFM/temp/email.txt
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

  if [ -f /home/david/TFM/temp/metaGoofLog.txt ]; then
    rm /home/david/TFM/temp/metaGoofLog.txt
  fi

  metagoofil -d $domain -t pdf,doc,xls,docx,xlsx -o /home/david/TFM/temp -f /home/david/TFM/temp/metaGoof.html > /home/david/TFM/temp/metaGoofLog.txt

  if [ $? -ne 0 ]; then
    echo "Error en la ejecución de Metagoofil"
  else
    echo "Ficheros .pdf del dominio $domain recuperados en /home/david/TFM/temp"
    echo "Guardando información en la base de datos. Tabla: T_METAGOOF"
    sqlite3 /home/david/TFM/BDD.db 'DELETE FROM T_METAGOOF;'
      while read p; do
        line=$(echo "'""$p""'")
        sqlite3 /home/david/TFM/BDD.db 'INSERT INTO T_METAGOOF(DOCUMENTO) VALUES ('$line');'
      done </home/david/TFM/temp/metaGoof.html

  fi
}

_theHarvester(){
  domain=$1

  if [ -f /home/david/TFM/temp/theHarvestLog.txt ]; then
    rm /home/david/TFM/temp/theHarvestLog.txt
  fi

  theHarvester -d $domain -b all -f /home/david/TFM/temp/theHarvest.xml > /home/david/TFM/temp/theHarvestLog.txt

  if [ $? -ne 0 ]; then
    echo "Error en la ejecución de theHarvester"
  else
    echo "Resultados de la ejecución de theHarvester sobre $domain recuperados en /home/david/TFM/temp"

    xmllint --format /home/david/TFM/temp/theHarvest.xml > /home/david/TFM/temp/theHarvest.txt
    cat /home/david/TFM/temp/theHarvest.txt| tr -d "[:blank:]" > /home/david/TFM/temp/theHarvest2.txt && mv /home/david/TFM/temp/theHarvest2.txt /home/david/TFM/temp/theHarvest.txt
    sed '/^<\//d' /home/david/TFM/temp/theHarvest.txt > /home/david/TFM/temp/theHarvest2.txt && mv /home/david/TFM/temp/theHarvest2.txt /home/david/TFM/temp/theHarvest.txt
    sed -n -e '/^<host>/p' /home/david/TFM/temp/theHarvest.txt > /home/david/TFM/temp/hosts.txt

    if [ -s /home/david/TFM/temp/hosts.txt ]; then
      #echo "hosts.txt no está vacío"
      sed -e 's!<host>!!' /home/david/TFM/temp/hosts.txt > /home/david/TFM/temp/hosts2.txt && mv /home/david/TFM/temp/hosts2.txt /home/david/TFM/temp/hosts.txt
      sed -e 's!</host>!!' /home/david/TFM/temp/hosts.txt > /home/david/TFM/temp/hosts2.txt && mv /home/david/TFM/temp/hosts2.txt /home/david/TFM/temp/hosts.txt
      sed -i '/^$/d' /home/david/TFM/temp/hosts.txt
      sqlite3 /home/david/TFM/BDD.db 'DELETE FROM T_THEHARVEST;'
      while read p; do
        line=$(echo "'""$p""'")
        sqlite3 /home/david/TFM/BDD.db 'INSERT INTO T_THEHARVEST(TIPO,DOCUMENTO) VALUES ("HOST",'$line');'
      done </home/david/TFM/temp/hosts.txt
    fi


    sed -n -e '/^<hostname>/p' /home/david/TFM/temp/theHarvest.txt > /home/david/TFM/temp/hostname.txt
    
    if [ -s /home/david/TFM/temp/hostname.txt ]; then
      #echo "hostname.txt no está vacío"
      sed -e 's!<hostname>!!' /home/david/TFM/temp/hostname.txt > /home/david/TFM/temp/hostname2.txt && mv /home/david/TFM/temp/hostname2.txt /home/david/TFM/temp/hostname.txt
      sed -e 's!</hostname>!!' /home/david/TFM/temp/hostname.txt > /home/david/TFM/temp/hostname2.txt && mv /home/david/TFM/temp/hostname2.txt /home/david/TFM/temp/hostname.txt
      sed -i '/^$/d' /home/david/TFM/temp/hostname.txt
      
      while read p; do
        line=$(echo "'""$p""'")
        sqlite3 /home/david/TFM/BDD.db 'INSERT INTO T_THEHARVEST(TIPO,DOCUMENTO) VALUES ("HOSTNAME",'$line');'
      done </home/david/TFM/temp/hostname.txt
    fi


    sed -n -e '/^<email>/p' /home/david/TFM/temp/theHarvest.txt > /home/david/TFM/temp/email.txt

    if [ -s /home/david/TFM/temp/email.txt ]; then
      #echo "email.txt no está vacío"
      sed -e 's!<email>!!' /home/david/TFM/temp/email.txt > /home/david/TFM/temp/email2.txt && mv /home/david/TFM/temp/email2.txt /home/david/TFM/temp/email.txt
      sed -e 's!</email>!!' /home/david/TFM/temp/email.txt > /home/david/TFM/temp/email2.txt && mv /home/david/TFM/temp/email2.txt /home/david/TFM/temp/email.txt
      sed -i '/^$/d' /home/david/TFM/temp/email.txt
      
      while read p; do
        line=$(echo "'""$p""'")
        sqlite3 /home/david/TFM/BDD.db 'INSERT INTO T_THEHARVEST(TIPO,DOCUMENTO) VALUES ("EMAIL",'$line');'
      done </home/david/TFM/temp/email.txt
    fi


    sed -n -e '/^<ip>/p' /home/david/TFM/temp/theHarvest.txt > /home/david/TFM/temp/ip.txt

    if [ -s /home/david/TFM/temp/ip.txt ]; then
      #echo "ip.txt no está vacío"
      sed -e 's!<ip>!!' /home/david/TFM/temp/ip.txt > /home/david/TFM/temp/ip2.txt && mv /home/david/TFM/temp/ip2.txt /home/david/TFM/temp/ip.txt
      sed -e 's!</ip>!!' /home/david/TFM/temp/ip.txt > /home/david/TFM/temp/ip2.txt && mv /home/david/TFM/temp/ip2.txt /home/david/TFM/temp/ip.txt
      sed -i '/^$/d' /home/david/TFM/temp/ip.txt
      
      while read p; do
        line=$(echo "'""$p""'")
        sqlite3 /home/david/TFM/BDD.db 'INSERT INTO T_THEHARVEST(TIPO,DOCUMENTO) VALUES ("IP",'$line');'
      done </home/david/TFM/temp/ip.txt
    fi
  fi
}

_nmap(){
  domain=$1
  
  if [ -f /home/david/TFM/temp/nmap_output.txt ]; then
    rm /home/david/TFM/temp/nmap_output.txt
  fi

  nmap -sV --script=vulscan/vulscan.nse --script-args vulscandb=cve.csv $domain > /home/david/TFM/temp/nmapLog.txt

  if [ $? -ne 0 ]; then
    echo "Error en la ejecución de nmap"
  else


    sed "$(( $(wc -l </home/david/TFM/temp/nmapLog.txt)-3 )),$ d" /home/david/TFM/temp/nmapLog.txt > /home/david/TFM/temp/nmapMod.txt 
    sed -e '1,6d' /home/david/TFM/temp/nmapMod.txt > /home/david/TFM/temp/nmapLog.txt
    sed '/^|_/d' /home/david/TFM/temp/nmapLog.txt > /home/david/TFM/temp/nmapMod.txt
    sed '/^| vulscan/d' /home/david/TFM/temp/nmapMod.txt > /home/david/TFM/temp/nmapLog.txt
    sed -r '/^.{,3}$/d' /home/david/TFM/temp/nmapLog.txt > /home/david/TFM/temp/nmapMod.txt
    sed '/closed/d' /home/david/TFM/temp/nmapMod.txt > /home/david/TFM/temp/nmapLog.txt


    sqlite3 /home/david/TFM/BDD.db 'DELETE FROM T_NMAP;'
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
          sqlite3 /home/david/TFM/BDD.db <<END_SQL
          INSERT INTO T_NMAP(PUERTO,INFO) VALUES ('$puerto','$part');
END_SQL

        done
      fi 2>/dev/null

      if [ $flag -eq 0 ]; then
        linea=$(echo $line | sed 's/^..//')
        
        sqlite3 /home/david/TFM/BDD.db <<END_SQL
          INSERT INTO T_NMAP(PUERTO,INFO) VALUES ('$puerto','$linea');
END_SQL
      fi  2>/dev/null

    done </home/david/TFM/temp/nmapLog.txt
    echo "Resultados de la ejecución de nmap sobre $domain recuperados en /home/david/TFM/temp"
  fi
}

_report(){
  domain=$1
  _repPortada $domain
  _repManifiesto

  _repMetagoofil
  _repHarvester

  pandoc /home/david/TFM/Reporte/Reporte.md -o /home/david/TFM/Reporte/Reporte.pdf
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

if [ ! -d "/home/david/TFM/Reporte" ]; then
  mkdir /home/david/TFM/Reporte
fi

echo "---" > /home/david/TFM/Reporte/Reporte.md
echo "title: Informe sobre el dominio "$domain >> /home/david/TFM/Reporte/Reporte.md
echo "author: David Hervás Rodríguez" >> /home/david/TFM/Reporte/Reporte.md
echo "date: "$fechaRep >> /home/david/TFM/Reporte/Reporte.md
echo "---" >> /home/david/TFM/Reporte/Reporte.md
echo "![](/home/david/TFM/temp/LogoUNED.jpg)" >> /home/david/TFM/Reporte/Reporte.md
printf '%s' '\newpage' >> /home/david/TFM/Reporte/Reporte.md

}

_repManifiesto(){
echo "\n\n# Manifiesto" >> /home/david/TFM/Reporte/Reporte.md
echo "\n" >> /home/david/TFM/Reporte/Reporte.md
_banner 1 >> /home/david/TFM/Reporte/Reporte.md
echo "\n" >> /home/david/TFM/Reporte/Reporte.md
echo "El objetivo de este trabajo final de máster es el análisis, diseño y desarrollo de la aplicación AutoPenTest que permite la automatización de las etapas de auditorías
técnicas de seguridad o pentesting hasta la explotación. La aplicación recibe como entrada el dominio objetivo del análisis. Mediante técnicas de auditoría activas y/o pasivas, 
y con el uso de herramientas de pentesting, se implementan de manera automática las primeras tres etapas del proceso de pentesting.\n" >> /home/david/TFM/Reporte/Reporte.md
echo "El objetivo de este informe, diseñado como conclusión de la aplicación AutoPenTest es mostrar la infraestructura descubierta así como las vulnerabilidades detectadas 
incluyendo la información recogida a lo largo de todo el proceso.\n" >> /home/david/TFM/Reporte/Reporte.md
printf '%s' '\vfill' >> /home/david/TFM/Reporte/Reporte.md
echo "\n# Referencias" >> /home/david/TFM/Reporte/Reporte.md
echo "\n" >> /home/david/TFM/Reporte/Reporte.md
echo "[Etapa 1 - Reconocimiento] theHarvester, https://github.com/laramies/theHarvester \n" >> /home/david/TFM/Reporte/Reporte.md
echo "[Etapa 1 - Reconocimiento] metagoofil, http://www.edge-security.com/metagoofil.php \n" >> /home/david/TFM/Reporte/Reporte.md
echo "[Etapa 2 - Descubrimiento] NMAP, https://insecure.org/ \n" >> /home/david/TFM/Reporte/Reporte.md
echo "[Etapa 3 - Explotación] metasploit, https://metasploit.com/ \n" >> /home/david/TFM/Reporte/Reporte.md
printf '%s' '\newpage' >> /home/david/TFM/Reporte/Reporte.md
}

_repMetagoofil(){
  echo "\n\n# Etapa 1: Reconocimiento - metagoofil" >> /home/david/TFM/Reporte/Reporte.md
  sqlite3 /home/david/TFM/BDD.db "SELECT * FROM T_METAGOOF;" > /home/david/TFM/Reporte/metagoofil.txt
  
  printf '%s' '\begin{table}[!hbt]' >> /home/david/TFM/Reporte/Reporte.md
  printf '%s' '\begin{tabular}{|p{13cm}|}' >> /home/david/TFM/Reporte/Reporte.md
  printf '%s' '\hline  \textbf{metagoofil} \\ \hline \\' >> /home/david/TFM/Reporte/Reporte.md

  aux=1
  while IFS= read -r line
  do

    if [ "$aux" -eq "0" ]; then
      printf '%s' '\begin{table}[!hbt]' >> /home/david/TFM/Reporte/Reporte.md
      printf '%s' '\begin{tabular}{|p{13cm}|}' >> /home/david/TFM/Reporte/Reporte.md
      #printf '%s' '\hline' >> /home/david/TFM/Reporte/Reporte.md
      printf '%s' '\hline  \textbf{metagoofil} \\ \hline \\' >> /home/david/TFM/Reporte/Reporte.md
    fi

    printf '%s' '\url{'$line'} \\ \\' >> /home/david/TFM/Reporte/Reporte.md
    aux=$((aux+1))

    if [ "$aux" -eq "17" ]; then
      printf '%s' '\hline \end{tabular}' >> /home/david/TFM/Reporte/Reporte.md
      printf '%s' '\end{table}' >> /home/david/TFM/Reporte/Reporte.md
      printf '%s' '\vfill' >> /home/david/TFM/Reporte/Reporte.md
      printf '%s' '\newpage' >> /home/david/TFM/Reporte/Reporte.md
      aux=0
    fi
  done </home/david/TFM/Reporte/metagoofil.txt

  printf '%s' '\hline \end{tabular}' >> /home/david/TFM/Reporte/Reporte.md
  printf '%s' '\end{table}' >> /home/david/TFM/Reporte/Reporte.md
  printf '%s' '\vfill' >> /home/david/TFM/Reporte/Reporte.md
  printf '%s' '\newpage' >> /home/david/TFM/Reporte/Reporte.md
}

_repHarvester(){

  echo "\n\n# Etapa 1: Reconocimiento - theHarvester" >> /home/david/TFM/Reporte/Reporte.md
  sqlite3 /home/david/TFM/BDD.db "select DOCUMENTO from T_THEHARVEST WHERE TIPO='HOST' LIMIT 50;" > /home/david/TFM/Reporte/theHarvHost.txt
  #sed -e 's!HOST|!!' /home/david/TFM/Reporte/theHarvHost.txt > /home/david/TFM/Reporte/theHarvHost2.txt && 
  sqlite3 /home/david/TFM/BDD.db "select DOCUMENTO from T_THEHARVEST WHERE TIPO='HOSTNAME' LIMIT 50;" > /home/david/TFM/Reporte/theHarvHostname.txt
  sqlite3 /home/david/TFM/BDD.db "select DOCUMENTO from T_THEHARVEST WHERE TIPO='IP' LIMIT 50;" > /home/david/TFM/Reporte/theHarvIp.txt
  sqlite3 /home/david/TFM/BDD.db "select DOCUMENTO from T_THEHARVEST WHERE TIPO='EMAIL' LIMIT 50;" > /home/david/TFM/Reporte/theHarvEmail.txt


  ##########HOST############
  printf '%s' '\begin{table}[!hbt]' >> /home/david/TFM/Reporte/Reporte.md
  printf '%s' '\begin{tabular}{|p{13cm}|}' >> /home/david/TFM/Reporte/Reporte.md
  printf '%s' '\hline  \textbf{theHarvester} \\' >> /home/david/TFM/Reporte/Reporte.md
  printf '%s' '\hline  \textbf{Hosts} \\ \hline' >> /home/david/TFM/Reporte/Reporte.md

  aux=1
  while IFS= read -r line
  do

    if [ "$aux" -eq "0" ]; then
      printf '%s' '\begin{table}[!hbt]' >> /home/david/TFM/Reporte/Reporte.md
      printf '%s' '\begin{tabular}{|p{13cm}|}' >> /home/david/TFM/Reporte/Reporte.md
      printf '%s' '\hline  \textbf{theHarvester} \\' >> /home/david/TFM/Reporte/Reporte.md
      printf '%s' '\hline  \textbf{Hosts} \\ \hline' >> /home/david/TFM/Reporte/Reporte.md
    fi

    #printf '%s' '\url{'$line'} \\ \\' >> /home/david/TFM/Reporte/Reporte.md
    printf '%s' $line ' \\'>> /home/david/TFM/Reporte/Reporte.md
    aux=$((aux+1))

    if [ "$aux" -eq "40" ]; then
      printf '%s' '\hline \end{tabular}' >> /home/david/TFM/Reporte/Reporte.md
      printf '%s' '\end{table}' >> /home/david/TFM/Reporte/Reporte.md
      printf '%s' '\vfill' >> /home/david/TFM/Reporte/Reporte.md
      printf '%s' '\newpage' >> /home/david/TFM/Reporte/Reporte.md
      aux=0
    fi
  done </home/david/TFM/Reporte/theHarvHost.txt

  printf '%s' '\hline \end{tabular}' >> /home/david/TFM/Reporte/Reporte.md
  printf '%s' '\end{table}' >> /home/david/TFM/Reporte/Reporte.md
  printf '%s' '\vfill' >> /home/david/TFM/Reporte/Reporte.md
  printf '%s' '\newpage' >> /home/david/TFM/Reporte/Reporte.md


  ##########HOSTNAMES############
  printf '%s' '\begin{table}[!hbt]' >> /home/david/TFM/Reporte/Reporte.md
  printf '%s' '\begin{tabular}{|p{13cm}|}' >> /home/david/TFM/Reporte/Reporte.md
  printf '%s' '\hline  \textbf{theHarvester} \\' >> /home/david/TFM/Reporte/Reporte.md
  printf '%s' '\hline  \textbf{Hostnames} \\ \hline' >> /home/david/TFM/Reporte/Reporte.md

  aux=1
  while IFS= read -r line
  do

    if [ "$aux" -eq "0" ]; then
      printf '%s' '\begin{table}[!hbt]' >> /home/david/TFM/Reporte/Reporte.md
      printf '%s' '\begin{tabular}{|p{13cm}|}' >> /home/david/TFM/Reporte/Reporte.md
      printf '%s' '\hline  \textbf{theHarvester} \\' >> /home/david/TFM/Reporte/Reporte.md
      printf '%s' '\hline  \textbf{Hostnames} \\ \hline' >> /home/david/TFM/Reporte/Reporte.md
    fi

    printf '%s' '\url{'$line'} \\' >> /home/david/TFM/Reporte/Reporte.md
    aux=$((aux+1))

    if [ "$aux" -eq "40" ]; then
      printf '%s' '\hline \end{tabular}' >> /home/david/TFM/Reporte/Reporte.md
      printf '%s' '\end{table}' >> /home/david/TFM/Reporte/Reporte.md
      printf '%s' '\vfill' >> /home/david/TFM/Reporte/Reporte.md
      printf '%s' '\newpage' >> /home/david/TFM/Reporte/Reporte.md
      aux=0
    fi
  done </home/david/TFM/Reporte/theHarvHostname.txt

  printf '%s' '\hline \end{tabular}' >> /home/david/TFM/Reporte/Reporte.md
  printf '%s' '\end{table}' >> /home/david/TFM/Reporte/Reporte.md
  printf '%s' '\vfill' >> /home/david/TFM/Reporte/Reporte.md
  printf '%s' '\newpage' >> /home/david/TFM/Reporte/Reporte.md  

  
  ##########IP############
  printf '%s' '\begin{table}[!hbt]' >> /home/david/TFM/Reporte/Reporte.md
  printf '%s' '\begin{tabular}{|p{13cm}|}' >> /home/david/TFM/Reporte/Reporte.md
  printf '%s' '\hline  \textbf{theHarvester} \\' >> /home/david/TFM/Reporte/Reporte.md
  printf '%s' '\hline  \textbf{Ips} \\ \hline' >> /home/david/TFM/Reporte/Reporte.md

  aux=1
  while IFS= read -r line
  do

    if [ "$aux" -eq "0" ]; then
      printf '%s' '\begin{table}[!hbt]' >> /home/david/TFM/Reporte/Reporte.md
      printf '%s' '\begin{tabular}{|p{13cm}|}' >> /home/david/TFM/Reporte/Reporte.md
      printf '%s' '\hline  \textbf{theHarvester} \\' >> /home/david/TFM/Reporte/Reporte.md
      printf '%s' '\hline  \textbf{Ips} \\ \hline' >> /home/david/TFM/Reporte/Reporte.md
    fi

    #printf '%s' '\url{'$line'} \\ \\' >> /home/david/TFM/Reporte/Reporte.md
    printf '%s' $line ' \\'>> /home/david/TFM/Reporte/Reporte.md
    aux=$((aux+1))

    if [ "$aux" -eq "40" ]; then
      printf '%s' '\hline \end{tabular}' >> /home/david/TFM/Reporte/Reporte.md
      printf '%s' '\end{table}' >> /home/david/TFM/Reporte/Reporte.md
      printf '%s' '\vfill' >> /home/david/TFM/Reporte/Reporte.md
      printf '%s' '\newpage' >> /home/david/TFM/Reporte/Reporte.md
      aux=0
    fi
  done </home/david/TFM/Reporte/theHarvIp.txt

  printf '%s' '\hline \end{tabular}' >> /home/david/TFM/Reporte/Reporte.md
  printf '%s' '\end{table}' >> /home/david/TFM/Reporte/Reporte.md
  printf '%s' '\vfill' >> /home/david/TFM/Reporte/Reporte.md
  printf '%s' '\newpage' >> /home/david/TFM/Reporte/Reporte.md


  ##########EMAIL############
  printf '%s' '\begin{table}[!hbt]' >> /home/david/TFM/Reporte/Reporte.md
  printf '%s' '\begin{tabular}{|p{13cm}|}' >> /home/david/TFM/Reporte/Reporte.md
  printf '%s' '\hline  \textbf{theHarvester} \\' >> /home/david/TFM/Reporte/Reporte.md
  printf '%s' '\hline  \textbf{Email} \\ \hline' >> /home/david/TFM/Reporte/Reporte.md

  aux=1
  while IFS= read -r line
  do

    if [ "$aux" -eq "0" ]; then
      printf '%s' '\begin{table}[!hbt]' >> /home/david/TFM/Reporte/Reporte.md
      printf '%s' '\begin{tabular}{|p{13cm}|}' >> /home/david/TFM/Reporte/Reporte.md
      printf '%s' '\hline  \textbf{theHarvester} \\' >> /home/david/TFM/Reporte/Reporte.md
      printf '%s' '\hline  \textbf{Email} \\ \hline' >> /home/david/TFM/Reporte/Reporte.md
    fi

    #printf '%s' '\url{'$line'} \\ \\' >> /home/david/TFM/Reporte/Reporte.md
    printf '%s' $line ' \\'>> /home/david/TFM/Reporte/Reporte.md
    aux=$((aux+1))

    if [ "$aux" -eq "40" ]; then
      printf '%s' '\hline \end{tabular}' >> /home/david/TFM/Reporte/Reporte.md
      printf '%s' '\end{table}' >> /home/david/TFM/Reporte/Reporte.md
      printf '%s' '\vfill' >> /home/david/TFM/Reporte/Reporte.md
      printf '%s' '\newpage' >> /home/david/TFM/Reporte/Reporte.md
      aux=0
    fi
  done </home/david/TFM/Reporte/theHarvEmail.txt

  printf '%s' '\hline \end{tabular}' >> /home/david/TFM/Reporte/Reporte.md
  printf '%s' '\end{table}' >> /home/david/TFM/Reporte/Reporte.md
  printf '%s' '\vfill' >> /home/david/TFM/Reporte/Reporte.md
  printf '%s' '\newpage' >> /home/david/TFM/Reporte/Reporte.md
}

_initBDD()
{
 sqlite3 /home/david/TFM/BDD.db 'CREATE TABLE IF NOT EXISTS T_METAGOOF(DOCUMENTO TEXT);' 2>/dev/null
 sqlite3 /home/david/TFM/BDD.db 'CREATE TABLE IF NOT EXISTS T_THEHARVEST(TIPO TEXT,DOCUMENTO TEXT);' 2>/dev/null

 sqlite3 /home/david/TFM/BDD.db 'CREATE TABLE IF NOT EXISTS T_NMAP(PUERTO INT,INFO TEXT);' 2>/dev/null
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