#!/bin/bash

echo "Launching GPTWOL..."

# Launch Cron
cron

# Configuración de Timeouts
# Si API_CHECK_TIMEOUT no está definido, usamos 30 por defecto
APP_TIMEOUT=${API_CHECK_TIMEOUT:-30}

# Calculamos el timeout de Gunicorn (margen de seguridad de +10s)
# para que Flask pueda responder "KO" antes de que el servidor lo mate.
GUNICORN_TIMEOUT=$((APP_TIMEOUT + 10))

echo "Configured API Timeout: $APP_TIMEOUT s"
echo "Configured Gunicorn Timeout: $GUNICORN_TIMEOUT s"

# Launch application
cd /app

# Añadimos --timeout a las GUNICORN_CMD_ARGS
# Nota: Cambié 'wol:app' por 'app:app' si tu archivo se llama app.py, 
# pero mantengo 'wol:app' si ese es el nombre de tu archivo principal.
GUNICORN_CMD_ARGS="--bind=$IP:$PORT --timeout=$GUNICORN_TIMEOUT --access-logfile -"

exec gunicorn $GUNICORN_CMD_ARGS app:app
