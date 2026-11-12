# MQTT Broker con Docker Compose

Este stack levanta un broker **Eclipse Mosquitto** con usuario/contraseña configurables.

## Uso

1. Configurar variables de entorno

  ```bash
  cp .env.example .env
  ```

2. Levantar los servicios de docker:

   ```bash
   docker compose up -d
   ```
3. Generar un token administrativo para InfluxDB3

  ```bash
  docker exec -it influxdb3-core influxdb3 create token --admin
  ```
4. Copiar el token generado al .env y reinciar los servicios

  ```bash
  docker compose up -d
  ```

5. Variables configurables (en `docker-compose.yml`):
   - `MQTT_USERNAME` (por defecto: `mqtt`)
   - `MQTT_PASSWORD` (por defecto: `lasdpc`)
   - `ALLOW_ANONYMOUS` (`false` o `true`)
   - `MQTT_PORT` (por defecto: `1883`)
   - `WS_ENABLED` (`true` o `false`)
   - `WS_PORT` (por defecto: `9001`)

6. Probar conexión:

   ```bash
   mosquitto_sub -h localhost -p 1883 -u "mqtt" -P "lasdpc" -t "test/topic" -v
   mosquitto_pub -h localhost -p 1883 -u "mqtt" -P "lasdpc" -t "test/topic" -m "Hola MQTT"
   ```

## Tópicos y Modelo de Datos

### 1. Sensor de Temperatura

- Topico: `lab1006/sensor/temperature/SensorTemperature`
- Descripcion del topico: Publica periódicamente (cada 5 s) las lecturas simuladas de temperatura de los sensores ubicados en el datacenter y laboratorio.
- Data:

  ```yml
  table: temperature
  tags:
    type: SensorTemperature
    id: sensor_id (string, ej: sensor_temperature1 .. 7, sensor_temperature_outside)
    mqtt_client_id: client_id (string, ej: SensorTemperature-sensor-452)
    agent_monitor_id: agent_monitor_id (string, ej: AGENTX)
  fields:
    # °C
    sensed_value: temperature (float)
    date_time: date_time (string, formato: MM/DD/YYYY HH:MM:SS)
  ```

### 2. Sensor de Presencia

- Topico: `lab1006/sensor/presence/SensorPresence`
- Descripcion del topico: Publica periódicamente (cada 5 s) el estado de detección y el usuario presente (profesor, estudiante, etc.) asignado a la plataforma monitoreada.
- Data:

  ```yml
  table: presence
  tags:
    type: SensorPresence
    id: sensor_id (string, ej: sensor_presence1, sensor_presence2)
    mqtt_client_id: client_id (string, ej: SensorPresence-sensor-120)
    agent_monitor_id: agent_monitor_id (string, ej: AGENTX, user_professor1)
    # Metadatos del usuario presente (si se detecta presencia)
    presence_id_user: presence.id_user (string, ej: user_professor1)
    presence_rol: presence.rol (string, ej: Professor, Postgraduate, Undergraduate)
  fields:
    # 0: ausente / 1: presente
    sensed_value: presence_detected (int)
    date_time: date_time (string, formato: MM/DD/YYYY HH:MM:SS)
  ```

### 3. Controlador de activos

- Topico: `lab1006/control/assets`
- Descripcion del topico: Publicación periódica (cada 5 s al presionar "Connect asset controller" en el simulador) del estado consolidado de los activos del laboratorio y datacenter (aires acondicionados, racks de datacenters, lámparas, calefactor, puertas, ventanas).
- Data:

  ```yml
  table: asset_status
  tags:
    id: asset_controller
    asset_id: asset.id (string, ej: asset_aircond1, asset_datacenter1, asset_lamp1)
    asset_type: asset.type (string, ej: AssetAircond, AssetDatacenter, AssetLamp)
  fields:
    # ON / OFF
    status: status (string)
    datetime: datetime (string, formato: DD/MM/YYYY HH:MM:SS)
  ```
