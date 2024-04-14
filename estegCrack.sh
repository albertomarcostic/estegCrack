#!/bin/bash

# estegCrack v1.0, Author @albertomarcostic https://github.com/albertomarcostic

#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"


function ctrl_c(){
    echo -e "\n\n${redColour}[!] ${grayColour}Saliendo...${endColour}\n"
    tput cnorm; exit 1
}

# Ctrl+C
trap ctrl_c SIGINT


# Rutas
diccionario_defecto="/usr/share/wordlists/rockyou.txt"
output=""
nIntentos=0


echo -e "${blueColour}  ______     _              _____                _    "
echo -e ' |  ____|   | |            / ____|              | |   '
echo -e ' | |__   ___| |_ ___  __ _| |     _ __ __ _  ___| | __'
echo -e ' |  __| / __| __/ _ \/ _` | |    | `__/ _` |/ __| |/ /'
echo -e ' | |____\__ \ ||  __/ (_| | |____| | | (_| | (__|   < '
echo -e ' |______|___/\__\___|\__, |\_____|_|  \__,_|\___|_|\_\'
echo -e '                      __/ | '                           
echo -e '                     |___/  '

echo -e "                                                v1.0"
echo -e "                                     Author: @albertomarcostic"
echo -e "                                           https://github.com/albertomarcostic${endColour}"



# FunciÃ³n para mostrar la ayuda del script
mostrar_ayuda() {
    echo -e "\n${blueColour}[+] ${grayColour}Uso: $0 -i <nombre_imagen> [-w <nombre_diccionario>]${endColour}"
    echo -e "  ${yellowColour}-i ${grayColour}<nombre_imagen>: Especifica el nombre de la imagen/archivo.${endColour}"
    echo -e "  ${yellowColour}-w ${grayColour}<nombre_diccionario>: (Opcional) Especifica el nombre del diccionario.${endColour}"
    echo -e "                             ${grayColour}Si no se proporciona, se utilizarÃ¡ el diccionario RockYou por defecto.${endColour}"
    echo -e "${yellowColour}[!] ${grayColour}Ejemplo: $0 -i imagen.jpg -w diccionario.txt${endColour}\n"
}

# Verificar si se proporcionan argumentos al script
if [ $# -eq 0 ]; then
    mostrar_ayuda
    exit 1
fi


# Procesar los argumentos
while getopts ":i:w:" opcion; do
    case $opcion in
        i)
            nombre_image=$OPTARG
            ;;
        w)
            nombre_diccionario=$OPTARG
            ;;
        \?)
            echo -e "\n${redColour}[!] ${grayColour}OpciÃ³n invÃ¡lida: -$OPTARG ${endColour}" >&2
            mostrar_ayuda
            exit 1
            ;;
        :)
            echo -e "\n${redColour}[!] ${grayColour}La opciÃ³n -$OPTARG requiere un argumento.${endColour}" >&2
            mostrar_ayuda
            exit 1
            ;;
    esac 
done

# Verificar si se proporcionÃ³ el argumento -i
if [ -z "$nombre_image" ]; then
    echo -e "${redColour}[!] ${grayColour}Debe especificar el nombre de la imagen con la opciÃ³n -i.${endColour}" >&2
    mostrar_ayuda
    exit 1
fi

# Si no se proporciona el nombre del diccionario, se usa el diccionario por defecto
if [ -z "$nombre_diccionario" ]; then
    nombre_diccionario="$diccionario_defecto"
fi

# Verificar si el diccionario existe y tiene permisos de lectura
if [ ! -f "$nombre_diccionario" ]; then
    echo -e "\n${redColour}[!] ${grayColour}El diccionario $nombre_diccionario no existe en la ruta indicada${endColour}"
    exit 1
elif [ ! -r "$nombre_diccionario" ]; then
    echo -e "\n${redColour}[!] ${grayColour}No tienes permisos de lectura para el diccionario $nombre_diccionario${endColour}"
    exit 1
fi

# Ruta absoluta

crack_image=$(readlink -f "$nombre_image")


# Verificar si el archivo penguin.jpg existe
if [ ! -f "$crack_image" ]; then
    echo -e "\n${redColour}[!] ${grayColour}El archivo $crack_image no existe en la ruta indicada${endColour}"
    exit 1
fi

# Comprobar si steghide estÃ¡ instalado
if ! command -v steghide &> /dev/null; then
    echo -e "\n${redColour}[!] ${grayColour}Steghide no estÃ¡ instalado. Por favor, instÃ¡lelo antes de continuar.${endColour}"
    exit 1
fi

while IFS= read -r password; do

    output=$(steghide --extract -sf "$crack_image" -p "$password" 2>&1)

    let "nIntentos++"

    if [[ $output == *"no pude"* ]]; then
        echo -ne "${yellowColour}[+] ${grayColour}Probando la contraseÃ±a: $password\r"
        echo -ne "${yellowColour}[+] ${grayColour} NÃºmero de contraseÃ±as probadas: $nIntentos\r${endColour}"
    else
        echo -e "\n${grayColour}---------------------------------------------------------------${endColour}"
        echo -e "\n${greenColour}[+] ${grayColour} ContraseÃ±a encontrada: $password${endColour}"
        echo -e "\n${greenColour}[+] ${grayColour} Archivo/s extraÃ­dos!${endColour}"
        exit 1
    fi
done < "$nombre_diccionario"

    echo -e "\n${grayColour}---------------------------------------------------------------${endColour}"
    echo -e "\n${redColour}[!] ${grayColour}No se ha podido encontrar la contraseÃ±a. Pruebe con otro diccionario de contraseÃ±as y compruebe que el archivo a crackear es el correcto. ${endColour}"
