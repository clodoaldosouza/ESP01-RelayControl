# ESP-01 Relay Control Server

This project was created using the [Ktor Project Generator](https://start.ktor.io).

This server provides a lightweight HTTP interface for controlling a relay connected to an ESP-01 module. It exposes two endpoints: one to **retrieve** the current relay status and another to **update** it remotely.

---

## Overview

The ESP-01 module connects to this server to:
- Check the current relay state (`true` or `false`)
- Update the relay state via HTTP POST
- Receive JSON-formatted responses

This allows remote control of physical devices using simple web requests.

---

## Endpoints

### `GET /status`

Returns the current relay status.

**Response:**
```json
{
  "relay": true
}
```

### `POST /update`

Updates the relay status.

**Request Body:**
```json
{
  "relay": false
}
```

**Successful Response:**
```json
{
  "success": true,
  "relay": false
}
```

---

## Technologies Used

- **Kotlin** as the main programming language
- **Ktor** framework for building asynchronous HTTP servers
- **JSON** for communication between client and server
- **PowerShell** or any HTTP client for manual control
- **Logging** for request tracking and debugging

---

## Kotlin + Ktor Usage

This server is built using **Kotlin**, a modern, expressive, and type-safe language that runs on the JVM. The **Ktor** framework is used to create the HTTP endpoints in a concise and readable way.

---

### Key Kotlin Features Used:
- **DSL-style routing** for defining endpoints
- **Data classes** for parsing JSON payloads
- **Coroutines** for non-blocking request handling
- **Structured logging** with IP tracking

---

## Integration with ESP-01

Pair this server with the ESP-01 firmware that:
- Connects to Wi-Fi
- Sends HTTP requests to `/status` and `/update`
- Parses JSON responses
- Toggles relay accordingly

---

## Example PowerShell Commands

**Check relay status:**
```powershell
Invoke-RestMethod -Uri "http://localhost:8080/status" -Method GET
```

**Change relay status on**
```powershell
Invoke-RestMethod -Uri "http://127.0.0.1:8080/update" -Method POST  -Headers @{ "Content-Type" = "application/json" }  -Body '{ "relay": true }'
```
**Change relay status off**
```powershell
Invoke-RestMethod -Uri "http://127.0.0.1:8080/update" -Method POST  -Headers @{ "Content-Type" = "application/json" }  -Body '{ "relay": false }'
```

---
