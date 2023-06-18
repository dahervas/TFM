#!/bin/bash

# creating a menu with the following options
echo "OPCIONES:";
echo "1. Asignar Dominio"
echo "2. Ejecutar análisis"
echo "3. Informe"
echo "4. Menu extendido"
echo "99. Salir"
echo -n "Escoge una opción [1-99]: "
echo " "
# Running a forever loop using while statement
# This loop will run until select the exit option.
# User will be asked to select option again and again
while :
do

# reading choice
read choice

# case statement is used to compare one value with the multiple cases.
case $choice in
  # Pattern 1
  1)  echo "Has seleccionado la opción 1"
      echo "Introduce el dominio a asignar: ";;
  # Pattern 2
  2)  echo "Has seleccionado la opción 2"
      echo "ANALISIS NO DISPONIBLE ";;
  # Pattern 3
  3)  echo "Has seleccionado la opción 3"
      echo "INFORME NO DISPONIBLE ";;    
  # Pattern 4
  4)  echo "Has seleccionado la opción 4"
      echo "MENU EXTENDIDO NO DISPONIBLE";;
  # Pattern 99
  99)  echo "Saliendo ..."
      exit;;
  # Default Pattern
  *) echo "Opcion inválida";;
  
esac
  echo -n "Escoge una opción [1-99]: "
done




#!/bin/sh
 
# Codigo que muestra como gestionar un menu desde consola.
# http://www.lawebdelprogramador.com
 
# Muestra el menu general
# _menu()
# {
#     echo "Selecciona una opcion:"
#     echo
#     echo "1) Opcion 1"
#     echo "2) Opcion 2"
#     echo "3) Opcion 3"
#     echo "4) Opcion 4"
#     echo "5) Opcion 5"
#     echo
#     echo "9) Salir"
#     echo
#     echo -n "Indica una opcion: "
# }
 
# # Muestra la opcion seleccionada del menu
# _mostrarResultado()
# {
#     clear
#     echo ""
#     echo "------------------------------------"
#     echo "Has seleccionado la opcion $1"
#     echo "------------------------------------"
#     echo ""
# }
 
# # opcion por defecto
# opc="0"
 
# # bucle mientas la opcion indicada sea diferente de 9 (salir)
# until [ "$opc" -eq "9" ];
# do
#     case $opc in
#         1)
#             _mostrarResultado $opc
#             _menu
#             ;;
#         2)
#             _mostrarResultado $opc
#             _menu
#             ;;
#         3)
#             _mostrarResultado $opc
#             _menu
#             ;;
#         4)
#             _mostrarResultado $opc
#             _menu
#             ;;
#         5)
#             _mostrarResultado $opc
#             _menu
#             ;;
#         *)
#             # Esta opcion se ejecuta si no es ninguna de las anteriores
#             clear
#             _menu
#             ;;
#     esac
#     read opc
# done