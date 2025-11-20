# MQTT Broker con Docker Compose

Este stack levanta un broker **Eclipse Mosquitto** con usuario/contraseña configurables.

## Uso

1. Construir e iniciar:
   ```bash
   docker compose up -d
   ```

2. Variables configurables (en `docker-compose.yml`):
   - `MQTT_USERNAME` (por defecto: `mqtt`)
   - `MQTT_PASSWORD` (por defecto: `lasdpc`)
   - `ALLOW_ANONYMOUS` (`false` o `true`)
   - `MQTT_PORT` (por defecto: `1883`)
   - `WS_ENABLED` (`true` o `false`)
   - `WS_PORT` (por defecto: `9001`)

3. Probar conexión:
   ```bash
   mosquitto_sub -h localhost -p 1883 -u "mqtt" -P "lasdpc" -t "test/topic" -v
   mosquitto_pub -h localhost -p 1883 -u "mqtt" -P "lasdpc" -t "test/topic" -m "Hola MQTT"
   ```
