#!/bin/bash

# Definir colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # Sin color

# Solicitar al usuario la carpeta de la base-library
# read -p "Ingresa el nombre de la base (ejm: demo_base [filename: demo_base-requirements.txt]): " base

# Listar las carpetas en el directorio actual
echo -e "${YELLOW}Selecciona la carpeta que contiene las librerías para instalar:${NC}"
select folder in ./*-library; do
    # Verificar que se haya seleccionado una opción válida
    if [ -d "$folder" ]; then
        echo -e "${BLUE}Has seleccionado la carpeta '${folder}'.${NC}"
        break
    else
        echo -e "${RED}Selección no válida. Inténtalo de nuevo.${NC}"
    fi
done

# Encontrar el archivo requirements.txt correspondiente
requirements_file=$(echo "$folder" | sed 's/-library$//')-requirements.txt

# Verificar si el archivo requirements.txt existe
if [ ! -f "$requirements_file" ]; then
    echo -e "${RED}No se encontró el archivo '${requirements_file}'. Abortando.${NC}"
    exit 1
fi

# Instalar las librerías desde la carpeta seleccionada
echo -e "${YELLOW}Instalando las librerías desde '${folder}' utilizando '${requirements_file}'...${NC}"
pip install --no-index --find-links="$folder" -r "$requirements_file"

echo -e "${GREEN}Instalación completada.${NC}"
