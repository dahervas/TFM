#!/bin/sh
 

# Muestra el banner del programa 
_banner()
{

  echo "         ********************************************************************"
  echo "         *                  _          ____          _________       _      *"
  echo "         *       /\        | |_       |     \       |___   ___|     | |_    *"
  echo "         *      /  \  _   _|  _| ___  |  H  |___  _ __  | | ___  ___|  _|   *"
  echo "         *     / /\ \| | | | |  /   \ |   _// _ \| '_ \ | |/ _ \/ __| |     *"
  echo "         *    / /  \ \ (_| | |_|  D  ||  | |  __/| | | || |  __/\__ \ |_    *"
  echo "         *    \/    \/\____|__| \___/ |__|  \___||_| |_||_|\___||___/___|   *"
  echo "         *                                                                  *"
  echo "         *                                                                  *"
  echo "         *  AutoPenTest  Versión 0.0.3                                      *"
  echo "         *  Codificado por D. Hervás Rodríguez                              *"
  echo "         *  dhervas18@alumnos.uned.es                                       *"
  echo "         *                                                                  *"
  echo "         ********************************************************************"
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
    echo "5) Opcion 5"
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

    if [ "$1" -eq "99" ]; then
      #sleep 3 & bash spinner.sh $!
      service postgresql start || exit

      msfconsole <<EOF
      sleep 5
      ?
      quit
EOF

    fi 

}

_mostrarError()
{
  echo ""
  echo "------------------------------------"
  echo "Has seleccionado una opción incorrecta"
  echo "------------------------------------"
  echo ""
}

_metaGoofil(){
  domain=$1

  if [ -f /home/david/TFM/temp/metaGoofLog.txt ]; then
    rm /home/david/TFM/temp/metaGoofLog.txt
  fi

  metagoofil -d $domain -t pdf -o /home/david/TFM/temp -f /home/david/TFM/temp/ficpdf.html > /home/david/TFM/temp/metaGoofLog.txt

  if [ $? -ne 0 ]; then
    echo "Error en la ejecución de Metagoofil"
  else
    echo "Ficheros .pdf del dominio $domain recuperados en /home/david/TFM/temp"
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
  fi
}

_nmap(){
  domain=$1
  
  if [ -f /home/david/TFM/temp/nmap_output.txt ]; then
    rm /home/david/TFM/temp/nmap_output.txt
  fi
  nmap -p- -oG /home/david/TFM/temp/nmap_output.txt $domain > /home/david/TFM/temp/nmapLog.txt

  if [ $? -ne 0 ]; then
    echo "Error en la ejecución de nmap"
  else
    echo "Resultados de la ejecución de nmap sobre $domain recuperados en /home/david/TFM/temp"
  fi
}

 
# opcion por defecto
opc="0"
 
# bucle mientas la opcion indicada sea diferente de 9 (salir)
until [ "$opc" -eq "9" ];
#while [ "$opc" -ne "9" ];
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