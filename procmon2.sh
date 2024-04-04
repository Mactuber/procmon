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

# Almacena la lista de tareas cron actual
old_crontab=$(crontab -l)

# Bucle infinito para monitorear los cambios en los procesos
while true; do
    # Obtiene los procesos actuales y sus usuarios
    new_process=$(ps -eo user,uid,command)

    # Obtiene la lista de tareas cron actual
    new_crontab=$(crontab -l)

    # Calcula las diferencias entre los procesos antiguos y nuevos
    diff_output_process=$(diff <(echo "$old_process") <(echo "$new_process") | grep "[\>\<]" | grep -v "kworker")

    # Calcula las diferencias entre las tareas cron antiguas y nuevas
    diff_output_crontab=$(diff <(echo "$old_crontab") <(echo "$new_crontab") | grep "[\>\<]")

    # Muestra solo las diferencias si hay cambios en los procesos
    if [ -n "$diff_output_process" ]; then
        # Imprime la fecha y hora actual
        current_date=$(date +"%a %b %e %T %Z %Y")
        echo "$current_date:"
        echo "$diff_output_process"
    fi

    # Muestra solo las diferencias si hay cambios en las tareas cron
    if [ -n "$diff_output_crontab" ]; then
        # Imprime la fecha y hora actual
        current_date=$(date +"%a %b %e %T %Z %Y")
        echo "$current_date:"
        echo "$diff_output_crontab"
    fi

    # Actualiza los procesos antiguos con los nuevos
    old_process="$new_process"

    # Actualiza las tareas cron antiguas con las nuevas
    old_crontab="$new_crontab"

    # Espera un intervalo antes de volver a verificar
    sleep 1
done
