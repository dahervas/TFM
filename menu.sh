#!/bin/sh
 
# Muestra el menu general
_menu()
{
    echo "##########"
    echo "DOMINIO: $dom"
    echo "##########"
    echo
    echo "Selecciona una opcion:"
    echo
    echo "1) Opcion Asignar Dominio"
    echo "2) Opcion 2"
    echo "3) Opcion 3"
    echo "4) Opcion 4"
    echo "5) Opcion 5"
    echo
    echo "9) Salir"
    echo
    echo -n "Indica una opcion: "
}
 
# Muestra la opcion seleccionada del menu
_mostrarResultado()
{
    clear
    echo ""
    echo "------------------------------------"
    echo "Has seleccionado la opcion $1"
    echo "------------------------------------"
    echo ""

    if [ "$1" -eq "1" ]; then
        #echo "Introduce el dominio: "
        read -p "Introduce el dominio: " dom
        echo
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