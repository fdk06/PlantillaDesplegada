#!/bin/bash

# Configuración
REPO_URL="https://github.com/fdk06/PlantillaDesplegada.git"  # Cambia esto con tu URL de GitHub
PROJECT_DIR="mi_proyecto"  # Nombre de la carpeta donde se clonará el repo
PORT=3000

# Instalar git, node y curl si no están en Termux
pkg install -y git nodejs curl

# Clonar el repositorio si no existe
if [ ! -d "$PROJECT_DIR" ]; then
    echo "Clonando el repositorio..."
    git clone "$REPO_URL" "$PROJECT_DIR"
else
    echo "El repositorio ya está clonado."
fi

# Moverse al directorio del proyecto
cd "$PROJECT_DIR" || exit

# Instalar dependencias
echo "Instalando dependencias..."
npm install

# Detener procesos en el puerto especificado
fuser -k $PORT/tcp 2>/dev/null

# Iniciar el servidor de Node.js en segundo plano
nohup node server.js > server.log 2>&1 &

# Esperar unos segundos para asegurarse de que el servidor arrancó
sleep 3

# Iniciar ngrok y obtener el enlace público
nohup ./ngrok http $PORT > ngrok.log 2>&1 &

# Esperar a que ngrok genere el enlace
sleep 3

# Extraer la URL pública de ngrok y mostrarla
NGROK_URL=$(curl -s http://127.0.0.1:4040/api/tunnels | grep -o 'https://[0-9a-z.-]*.ngrok-free.app')

if [ -z "$NGROK_URL" ]; then
    echo "Error: No se pudo obtener la URL de ngrok."
else
    echo "Tu servidor está disponible en: $NGROK_URL"
fi
