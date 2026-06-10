# 🚀 MQTT Broker with Docker Compose

This project deploys an **Eclipse Mosquitto** broker in a Docker container, with username/password authentication and optional WebSocket support.

---

## 📦 Prerequisites

- Docker and Docker Compose installed.
- Port `1883` (MQTT TCP) available on your host.
  *(If you already have another Mosquitto instance running, stop it or change the port in `docker-compose.yml`).*

---

## ▶️ Running

1. Clone this repository or copy the files (`docker-compose.yml`, `Dockerfile`, `docker-entrypoint.sh`).

2. Start the container:

   ```bash
   docker compose build --no-cache
   docker compose up -d
   ```

3. Verify that the container is running:

   ```bash
   docker ps
   docker logs -f mqtt-broker
   ```

   You should see a message like:
   ```
   ==> Starting Mosquitto on 0.0.0.0:1883 (WS:9001)
   mosquitto version 2.x.x starting
   ```

---

## 🔑 Default Credentials

- **Username:** `mqtt`
- **Password:** `lasdpc`
- **MQTT TCP Port:** `1883`
- **WebSocket Port:** `9001`

> You can change these values in `docker-compose.yml` under the `environment` section.

---

## 🧪 Testing the Broker

### 1. Subscribe to a topic

Open a terminal and run a subscriber client:

```bash
mosquitto_sub -h localhost -p 1883 -u "mqtt" -P "lasdpc" -t "test/topic" -v
```

It will wait for incoming messages.

---

### 2. Publish a message

In another terminal, publish a message to the same topic:

```bash
mosquitto_pub -h localhost -p 1883 -u "mqtt" -P "lasdpc" -t "test/topic" -m "Hello MQTT from Docker!"
```

You should see in the subscriber terminal:

```
test/topic Hello MQTT from Docker!
```

---

## 🛑 Stop and Clean

To stop the service:

```bash
docker compose down
```

If you want to rebuild everything from scratch (including volumes):

```bash
docker compose down -v
docker compose build --no-cache
docker compose up -d
```

---

## 📌 Notes

- If you want to enable **anonymous connections** (no username/password) for quick testing, edit `docker-compose.yml`:

  ```yaml
  environment:
    - ALLOW_ANONYMOUS=true
  ```

- Keep in mind that exposing an anonymous broker on public networks is not recommended.

---

