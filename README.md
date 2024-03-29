# TFM
Master's degree final project

=============================================
## AUTOPENTEST

# Requisitos previos
1.	Descargar Kali Linux. Desde el sitio web oficial se puede descargar la imagen ISO más reciente de Kali Linux: https://www.kali.org/get-kali/#kali-virtual-machines. Se debe escoger la opción adecuada a nuestro sistema y su arquitectura de las que se presentan.
2.  Instalar VirtualBox. De nuevo, desde el sitio oficial de VirtualBox se debe descargar e instalar la última versión o la que se considere más adecuada al sistema empleado.
3.  Se debe crear una máquina virtual con la imagen ISO Kali y configurarla (incluyendo el gestor de arranque GRUB).

# Despliegue de AutoPenTest
1.  Se debe instalar LaTeX mediante los comandos siguientes:
   
     ●	sudo apt-get install texlive
  
     ●	sudo apt-get -y install texlive-base texlive-latex-extra texlive-fonts-extra
  
3.  Se debe instalar xmllint mediante el comando:

     ●	apt-get install libxml2-utils
  
4.  Se debe instalar vulscan mediantes los comandos:

     ●	git clone https://github.com/scipag/vulscan scipag_vulscan
  
     ●	ln -s ``pwd``/scipag_vulscan /usr/share/nmap/scripts/vulscan
  
5.  Por último se deben descargar los ficheros menu.sh, spinner.sh y BDD.db del GitHub del proyecto (https://github.com/dahervas/TFM).
   
Una vez descargados, solo hay que depositarlos en un mismo repertorio y proceder con la ejecución del script menu.sh

=============================================
# VERSION 0.0.1

METAS ALCANZADAS:

-La primera opción es funcional (asignar dominio).

-El menú acepta un dominio, que se guarda en variable y permanece a lo largo de toda la ejecución.

=============================================

METAS PRÓXIMAS:

-Desarrollar las funcionalidades siguientes (reconocimiento, descubrimiento y explotación).

-Embellecer el menú.

-Limpiar el código del menú.

=============================================
# VERSION 0.0.2

METAS ALCANZADAS:

-La segunda opción es funcional (Ejecución Metagoofil).

-Con el parámetro (dominio) de la primera opción, se puede ejecutar la segunda para llevar a cabo una fase del reconocimiento.

=============================================

METAS PRÓXIMAS:

-Desarrollar las funcionalidades siguientes (reconocimiento, descubrimiento y explotación).

-Embellecer el menú.

-Limpiar el código del menú.

=============================================
# VERSION 0.0.3

METAS ALCANZADAS:

-La tercera opción es funcional (Ejecución theHarvester).

-Con el parámetro (dominio) de la primera opción, se pueden ejecutar la segunda y tercera para llevar a cabo la fase del reconocimiento.

-Añadido de un spinner para que el usuario sepa que se está realizando un proceso.

=============================================

METAS PRÓXIMAS:

-Desarrollar las funcionalidades siguientes (descubrimiento y explotación).

-Embellecer el menú.

-Limpiar el código del menú.

-Dar más capacidad de personalización para la ejecución de theHarvester, permitiendo al usuario introducir manualmente (si quiere) introducir los valores del parámetro -b (fuentes)

-Para permitir que el script sea ejecutable desde un entorno diferente, se pueden variabilizar las rutas donde se guardan los ficheros de ejecuciones y logs.

-Se está investigando la manera de añadir una barra de progreso para evitar que el usuario espere a la ejecución de las herramientas con una ventana inmóvil.

-Se está investigando la manera de evitar que google bloquee las búsquedas al detectar un gran número de peticiones (metagoofil) mediante proxys dinamicos o SSH.

=============================================
# VERSION 0.0.4

METAS ALCANZADAS:

-La cuarta opción es funcional (Ejecución nmap).

-Con el parámetro (dominio) de la primera opción, se puede ejecutar la cuarta para llevar a cabo la fase de descubrimiento.

=============================================

METAS PRÓXIMAS:

-Desarrollar las funcionalidades siguientes (explotación).

-Añadir un formateo de los ficheros de salida para generar un informe (txt y/o pdf).

-Embellecer el menú.

-Limpiar el código del menú.

-Dar más capacidad de personalización para la ejecución de theHarvester, permitiendo al usuario introducir manualmente (si quiere) introducir los valores del parámetro -b (fuentes)

-Para permitir que el script sea ejecutable desde un entorno diferente, se pueden variabilizar las rutas donde se guardan los ficheros de ejecuciones y logs.

-Se está investigando la manera de añadir una barra de progreso para evitar que el usuario espere a la ejecución de las herramientas con una ventana inmóvil.

-Se está investigando la manera de evitar que google bloquee las búsquedas al detectar un gran número de peticiones (metagoofil) mediante proxys dinamicos o SSH.

=============================================
# VERSION 0.0.5

METAS ALCANZADAS:

-La quinta opción es funcional (Ejecución Metasploit).

-La sexta opción es funcional (Generación reporte).

-Añadidos acuerdos de autorización y confidencialidad al Informe final

-El script es ejecutable desde un entorno diferente, se han variabilizado los repertorios y las rutas del script.

=============================================

METAS PRÓXIMAS:

-Embellecer el menú.

-Limpiar el código del menú.

-Dar más capacidad de personalización para la ejecución de theHarvester, permitiendo al usuario introducir manualmente (si quiere) introducir los valores del parámetro -b (fuentes)

-Se está investigando la manera de añadir una barra de progreso para evitar que el usuario espere a la ejecución de las herramientas con una ventana inmóvil.

-Se está investigando la manera de evitar que google bloquee las búsquedas al detectar un gran número de peticiones (metagoofil) mediante proxys dinamicos o SSH.

=============================================
