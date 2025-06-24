# Nginx Reverse Proxy + Docker Compose

This project sets up a reverse proxy architecture using **Docker Compose** with **Nginx** acting as a reverse proxy to two backend services:

- **Service 1** (Go HTTP server)
- **Service 2** (Python Flask API using `uv`)

The system exposes both services on a single port (`localhost:8080`) with **path-based routing**, centralized logging, and health checks.

---

## Project Structure

```
.
├── docker-compose.yaml
├── test.sh
├── nginx/
│   ├── Dockerfile
│   └── default.conf
├── service_1/
│   ├── Dockerfile
│   └── main.go
├── service_2/
│   ├── .venv/
│   ├── .dockerignore
│   ├── .python-version
│   ├── Dockerfile
│   ├── app.py
│   ├── pyproject.toml
│   └── uv.lock
```

---

## Setup Instructions

1. **Prerequisites**  
   Ensure you have the following installed:
   - Docker
   - Docker Compose

2. **Clone the Repository**

   ```bash
   git clone https://github.com/Janeesh23/Nginx_and_Docker_compose.git
   cd Nginx_and_Docker_compose/
   ```

3. **Build & Start the System**

   From the root directory:

   ```bash
   docker-compose up --build
   ```

4. **Test the Services**

   You can run the provided script to test routing and health:

   ```bash
   ./test.sh
   ```

---

## How Routing Works

Nginx is configured to handle path-based routing. Requests to specific paths are forwarded to different backend services:

| Route Prefix         | Routed To        | Port     | Description                         |
|----------------------|------------------|----------|-------------------------------------|
| `/service1/ping`     | Go service       | `8001`   | Health check for Service 1          |
| `/service1/hello`    | Go service       | `8001`   | Greeting from Service 1             |
| `/service2/ping`     | Python Flask app | `8002`   | Health check for Service 2          |
| `/service2/hello`    | Python Flask app | `8002`   | Greeting from Service 2             |

All routes are accessed via the Nginx container through:

```
http://localhost:8080
```

**Example:**
- http://localhost:8080/service1/hello → forwards to Service 1
- http://localhost:8080/service2/ping → forwards to Service 2

---

## Features Implemented

### 1. **Health Checks**
- Both services expose a `/ping` endpoint that returns:
  ```json
  { "status": "ok", "service": "<id>" }
  ```
- Used by:
  - Docker healthcheck
  - `test.sh` automation script

### 2. **Detailed Logging**
- Nginx logs include **timestamp, client IP, request path, and status code** in a clean, custom format:
  ```
  23/Jun/2025:16:54:15 +0000 | 172.18.0.1 | /service2/hello | 200
  ```

### 3. **Automated Test Script**
- `test.sh` performs:
  - Route checks (`ping` and `hello` for both services)
  - Displays matching Nginx log entries
  - Fails gracefully if any route is unreachable
  

### 4. **Production-Ready Dockerfiles**
- Go app uses multi-stage build
- Python Flask app uses `uv` runner in a minimal base image

---

