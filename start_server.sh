#!/bin/bash

# 1. Inicia el servidor Node.js en segundo plano
echo "Iniciando servidor Node.js..."
nohup node server.js > server.log 2>&1 &
echo "Servidor Node.js iniciado."

# Espera unos segundos para que el servidor arranque
sleep 3

# 2. Inicia LocalTunnel para exponer el puerto 3000
echo "Iniciando LocalTunnel en el puerto 3000..."
nohup lt --port 3000 > lt.log 2>&1 &
  
# Espera para que LocalTunnel se inicie y genere la URL pública
sleep 5

# 3. Extrae la URL pública desde el log de LocalTunnel
# La expresión regular busca algo del tipo "https://algo.loca.lt"
TUNNEL_URL=$(grep -o "https://[a-z0-9-]*\.loca\.lt" lt.log | head -n 1)

if [ -z "$TUNNEL_URL" ]; then
  echo "❌ No se pudo obtener la URL pública de LocalTunnel."
else
  echo "✅ La URL pública de LocalTunnel es: $TUNNEL_URL"
fi

# 4. Obtén el tunnel password (la IP pública)
echo "Obteniendo el tunnel password..."
TUNNEL_PASSWORD=$(curl -s https://loca.lt/mytunnelpassword)
echo "🔑 El tunnel password es: $TUNNEL_PASSWORD"
