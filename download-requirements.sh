#!/bin/bash

# Definir colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # Sin color

# Seleccionar el archivo base-requirements.txt
echo -e "${YELLOW}Selecciona el archivo base-requirements.txt:${NC}"
select requirements_file in ./*-requirements.txt; do
    if [ -f "$requirements_file" ]; then
        base=$(basename "$requirements_file" -requirements.txt)
        echo -e "${BLUE}Has seleccionado el archivo '${requirements_file}'.${NC}"
        break
    else
        echo -e "${RED}Selección no válida. Inténtalo de nuevo.${NC}"
    fi
done

# Definir el directorio de destino
library_dir="./${base}-library"

# Verificar si la carpeta ya existe
if [ -d "$library_dir" ]; then
    echo -e "${YELLOW}La carpeta '$library_dir' ya existe.${NC}"
    read -p "¿Deseas (E)liminar todos los archivos o (M)overlos a una carpeta de respaldo? (E/M): " action
    
    if [ "$action" == "E" ] || [ "$action" == "e" ]; then
        # Eliminar todos los archivos en la carpeta
        rm -rf "$library_dir"
        mkdir -p "$library_dir"
        echo -e "${GREEN}Carpeta '$library_dir' ha sido vaciada y está lista para nuevos archivos.${NC}"
    elif [ "$action" == "M" ] || [ "$action" == "m" ]; then
        # Mover los archivos a una carpeta de respaldo
        timestamp=$(date +"%Y%m%d-%H%M%S")
        backup_dir="./zbackup-${timestamp}-${base}-library"
        mkdir -p "$backup_dir"
        mv "$library_dir"/* "$backup_dir/"
        echo -e "${GREEN}Archivos movidos a la carpeta de respaldo '$backup_dir'.${NC}"
        mkdir -p "$library_dir"
        echo -e "${BLUE}Nueva carpeta '$library_dir' ha sido creada para nuevos archivos.${NC}"
    else
        echo -e "${RED}Opción no válida. Abortando.${NC}"
        exit 1
    fi
else
    # Crear la carpeta si no existe
    mkdir -p "$library_dir"
    echo -e "${GREEN}Carpeta '$library_dir' creada.${NC}"
fi

# Descargar las librerías y sus dependencias
echo -e "${YELLOW}Descargando las librerías y sus dependencias...${NC}"
pip3 download -r "$requirements_file" -d "$library_dir"

echo -e "${GREEN}Descarga completada.${NC}"
