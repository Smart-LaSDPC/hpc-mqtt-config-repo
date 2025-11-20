#!/usr/bin/env sh
set -e

: "${MQTT_USERNAME:=mqtt}"
: "${MQTT_PASSWORD:=lasdpc}"
: "${ALLOW_ANONYMOUS:=false}"
: "${MQTT_PORT:=1883}"
: "${WS_ENABLED:=true}"
: "${WS_PORT:=9001}"

mkdir -p /mosquitto/config /mosquitto/data /mosquitto/log

# Crear passwordfile si corresponde
if [ "$ALLOW_ANONYMOUS" = "true" ]; then
  rm -f /mosquitto/config/passwordfile 2>/dev/null || true
else
  if [ -n "$MQTT_USERNAME" ] && [ -n "$MQTT_PASSWORD" ]; then
    mosquitto_passwd -b -c /mosquitto/config/passwordfile "$MQTT_USERNAME" "$MQTT_PASSWORD"
  else
    echo "ERROR: Se requiere MQTT_USERNAME y MQTT_PASSWORD cuando ALLOW_ANONYMOUS=false"
    exit 1
  fi
fi

# Generar archivo de configuración
cat > /mosquitto/config/mosquitto.runtime.conf <<EOF
persistence true
persistence_location /mosquitto/data/

listener ${MQTT_PORT}
$( [ "$ALLOW_ANONYMOUS" = "true" ] && echo "allow_anonymous true" || echo "allow_anonymous false
password_file /mosquitto/config/passwordfile" )
EOF

if [ "$WS_ENABLED" = "true" ]; then
cat >> /mosquitto/config/mosquitto.runtime.conf <<EOF

listener ${WS_PORT}
protocol websockets
EOF
fi

# --- Ajustar permisos y propietario ---
MOSQ_UID=1883
MOSQ_GID=1883

if [ -f /mosquitto/config/passwordfile ]; then
  chmod 640 /mosquitto/config/passwordfile
fi
chmod 644 /mosquitto/config/mosquitto.runtime.conf

chown -R ${MOSQ_UID}:${MOSQ_GID} /mosquitto
# --- Fin ajuste ---

echo "==> Iniciando Mosquitto en 0.0.0.0:${MQTT_PORT} (WS:${WS_ENABLED:+$WS_PORT})"

exec mosquitto -c /mosquitto/config/mosquitto.runtime.conf
