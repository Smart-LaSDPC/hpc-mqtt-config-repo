# 🚀 MQTT Broker con Docker Compose

Este proyecto levanta un broker **Eclipse Mosquitto** en un contenedor Docker, con autenticación de usuario/contraseña y soporte opcional de WebSockets.

---

## 📦 Requisitos previos

- Tener Docker y Docker Compose instalados.
- Puerto `1883` (MQTT TCP) libre en tu host.  
  *(Si ya tienes otro Mosquitto corriendo en el sistema, deténlo o cambia el puerto en `docker-compose.yml`).*

---

## ▶️ Ejecución

1. Clona este repositorio o copia los archivos (`docker-compose.yml`, `Dockerfile`, `docker-entrypoint.sh`).

2. Levanta el contenedor:

   ```bash
   docker compose build --no-cache
   docker compose up -d
   ```

3. Verifica que el contenedor esté en ejecución:

   ```bash
   docker ps
   docker logs -f mqtt-broker
   ```

   Debes ver un mensaje como:
   ```
   ==> Iniciando Mosquitto en 0.0.0.0:1883 (WS:9001)
   mosquitto version 2.x.x starting
   ```

---

## 🔑 Credenciales por defecto

- **Usuario:** `mqtt`  
- **Password:** `lasdpc`  
- **Puerto TCP MQTT:** `1883`  
- **Puerto WebSocket:** `9001`

> Puedes cambiar estos valores en `docker-compose.yml` dentro de la sección `environment`.

---

## 🧪 Prueba del broker

### 1. Suscribirse a un tópico

En una terminal abre un cliente suscriptor:

```bash
mosquitto_sub -h localhost -p 1883 -u "mqtt" -P "lasdpc" -t "test/topic" -v
```

Quedará esperando mensajes.

---

### 2. Publicar un mensaje

En otra terminal publica un mensaje al mismo tópico:

```bash
mosquitto_pub -h localhost -p 1883 -u "mqtt" -P "lasdpc" -t "test/topic" -m "Hola MQTT desde Docker!"
```

Deberías ver en la terminal suscriptora:

```
test/topic Hola MQTT desde Docker!
```

---

## 🛑 Detener y limpiar

Para detener el servicio:

```bash
docker compose down
```

Si quieres reconstruir desde cero (limpiando volúmenes):

```bash
docker compose down -v
docker compose build --no-cache
docker compose up -d
```

---

## 📌 Notas

- Si quieres habilitar conexiones **anónimas** (sin usuario/contraseña) para pruebas rápidas, edita `docker-compose.yml`:

  ```yaml
  environment:
    - ALLOW_ANONYMOUS=true
  ```

- Recuerda que no es recomendable exponer un broker anónimo en redes públicas.

---
