#!/bin/bash

# 1. Verificar e instalar LocalTunnel si no está presente
echo "🔹 Verificando si LocalTunnel está instalado..."
if ! command -v lt &> /dev/null; then
    echo "LocalTunnel no está instalado. Instalando LocalTunnel globalmente..."
    npm install -g localtunnel
    if [ $? -ne 0 ]; then
      echo "❌ Error: No se pudo instalar LocalTunnel. Verifica tu conexión y permisos."
      exit 1
    fi
else
    echo "✅ LocalTunnel ya está instalado."
fi

# 2. Iniciar el servidor Node.js en segundo plano
echo "🔹 Iniciando servidor Node.js..."
nohup node server.js > server.log 2>&1 &
echo "✅ Servidor Node.js iniciado."

# Espera para que el servidor arranque
sleep 3

# 3. Iniciar LocalTunnel para exponer el puerto 3000
echo "🔹 Iniciando LocalTunnel en el puerto 3000..."
nohup lt --port 3000 > lt.log 2>&1 &
sleep 5

# 4. Extraer la URL pública desde el log de LocalTunnel
echo "🔹 Obteniendo la URL pública..."
TUNNEL_URL=$(grep -o "https://[a-z0-9-]*\.loca\.lt" lt.log | head -n 1)

if [ -z "$TUNNEL_URL" ]; then
    echo "❌ No se pudo obtener la URL pública de LocalTunnel."
else
    echo "✅ La URL pública de LocalTunnel es: $TUNNEL_URL"
fi

# 5. Obtener el tunnel password (la IP pública) usando curl
echo "🔹 Obteniendo el tunnel password..."
TUNNEL_PASSWORD=$(curl -s https://loca.lt/mytunnelpassword)
echo "🔑 El tunnel password es: $TUNNEL_PASSWORD"
