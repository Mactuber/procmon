#!/bin/bash

# Banner inicial
banner="
██████╗ ██████╗  ██████╗  ██████╗███╗   ███╗ ██████╗ ███╗   ██╗
██╔══██╗██╔══██╗██╔═══██╗██╔════╝████╗ ████║██╔═══██╗████╗  ██║
██████╔╝██████╔╝██║   ██║██║     ██╔████╔██║██║   ██║██╔██╗ ██║
██╔═══╝ ██╔══██╗██║   ██║██║     ██║╚██╔╝██║██║   ██║██║╚██╗██║
██║     ██║  ██║╚██████╔╝╚██████╗██║ ╚═╝ ██║╚██████╔╝██║ ╚████║
╚═╝     ╚═╝  ╚═╝ ╚═════╝  ╚═════╝╚═╝     ╚═╝ ╚═════╝ ╚═╝  ╚═══╝
                                                               
"

# Imprime el banner inicial
echo "$banner"

# Imprime el usuario que ejecuta el script
echo "El script está siendo ejecutado por el usuario: $USER"

# Imprime el separador superior
echo "--------------------------------------------------------------------------------------------"

# Almacena los procesos actuales y sus usuarios
old_process=$(ps -eo user,uid,command)

# Bucle infinito para monitorear los cambios en los procesos
while true; do
    # Obtiene los procesos actuales y sus usuarios
    new_process=$(ps -eo user,uid,command)

    # Calcula las diferencias entre los procesos antiguos y nuevos
    diff_output=$(diff <(echo "$old_process") <(echo "$new_process") | grep "[\>\<]" | grep -v "kworker")

    # Muestra solo las diferencias si hay cambios
    if [ -n "$diff_output" ]; then
        # Imprime la fecha y hora actual
        current_date=$(date +"%a %b %e %T %Z %Y")
        echo -n "$current_date: "

        # Imprime cada evento en una línea horizontal
        echo "$diff_output" | while IFS= read -r line; do
            user=$(echo "$line" | awk '{print $1}')
            uid=$(echo "$line" | awk '{print $2}')
            command=$(echo "$line" | awk '{$1=$2=""; print substr($0,3)}')
            echo -n "> $user ($uid): $command   "
        done
        echo "" # Salto de línea después de imprimir todos los eventos
    fi

    # Actualiza los procesos antiguos con los nuevos
    old_process="$new_process"

    # Espera un intervalo antes de volver a verificar
    sleep 1
done
