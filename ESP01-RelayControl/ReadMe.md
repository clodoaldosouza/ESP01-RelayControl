# ESP-01 Relay Controller via Server Status

This project uses the **ESP-01** module to remotely control a **relay** by connecting to a server and retrieving a `true` or `false` status to toggle the device.

---


## Overview

This C++ program performs the following steps:

1. Connects to a pre-configured Wi-Fi network.
2. Establishes communication with a remote server via HTTP.
3. Requests the current relay status (`true` or `false`).
4. Parses the server's JSON response.
5. Activates or deactivates the relay based on the received status.
6. Repeats the process at defined intervals or on demand.

---

## Requirements

- **ESP-01** module
- 5V relay compatible with ESP-01
- Stable power supply (min 250mA)
- Server with an HTTP endpoint returning JSON-formatted status
- C++ development environment for ESP8266 (e.g., PlatformIO)

---

## Expected JSON Format (Received and Sent)

To turn the relay **on**:
```json
{
  "relay": "true"
}
```
Turn relay off
```json
{
"relay": "false"
}
```

---
