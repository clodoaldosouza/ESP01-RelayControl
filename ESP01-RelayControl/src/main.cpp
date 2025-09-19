//
// Created by Clodoaldo Souza on 19/09/2025.
//

#include <Arduino.h>
#include <ArduinoJson.h>
#include <ESP8266HTTPClient.h>
#include <ESP8266WiFi.h>
#include <WiFiManager.h>

#define RELAY   0
#define LED     1

const char *topic = "relay";
const char *serverIP = "http://192.168.3.83";   // <- Change here
const int serverPort = 8080;                    // <- Change here if necessary

bool relayState = false;

void connectToWifi();

void tryToConnect();

void generateAccessPoint();

void receiveStatus(HTTPClient *http);

void sendStatus(HTTPClient *http);

void controlOutput();

void setup() {
    Serial.begin(115200);
    Serial.println("RelayControl V1.0");
    pinMode(LED, OUTPUT);
    pinMode(RELAY, OUTPUT);
    connectToWifi();
}

void generateAccessPoint() {
    WiFiManager wm;
    wm.setDebugOutput(true);
    wm.setConfigPortalTimeout(180);

    Serial.println("Network profile not detected. Initializing AP mode...");
    bool res = wm.autoConnect("RELAY_CONTROL", "RELAY123");
    if (!res) {
        Serial.println("Connection failed. Restarting system...");
        ESP.restart();
    }
}

void tryToConnect() {
    Serial.println("Wi-Fi network already saved. Connecting now...");
    WiFi.begin();
    int tries = 0;
    while (WiFi.status() != WL_CONNECTED && tries < 20) {
        delay(500);
        Serial.print(".");
        tries++;
    }
    if (WiFi.status() != WL_CONNECTED) {
        Serial.println("Connection failed. Restarting system...");
        ESP.restart();
    }
}

void connectToWifi() {
    if (WiFi.SSID() == "") {
        generateAccessPoint();
    } else {
        tryToConnect();
    }
    Serial.print("My IP: ");
    Serial.println(WiFi.localIP());
}

void sendStatus(HTTPClient *http) {
    WiFiClient client;
    String serverAddress = String(serverIP) + ":" + String(serverPort) + "/update";
    http->begin(client, serverAddress);
    http->addHeader("Content-Type", "application/json");

    JsonDocument outDoc;
    outDoc[topic] = relayState;
    String outJson;
    serializeJson(outDoc, outJson);

    int postCode = http->POST(outJson);
    if (postCode == HTTP_CODE_OK) {
        Serial.println("Status has been successfully submitted.");
    } else {
        Serial.printf("Failed to transmit status data: %d\n", postCode);
    }

    http->end();
}

void receiveStatus(HTTPClient *http) {
    WiFiClient client;
    String serverAddress = String(serverIP) + ":" + String(serverPort) + "/status";
    http->begin(client, serverAddress);
    int httpCode = http->GET();

    if (httpCode == HTTP_CODE_OK) {
        String payload = http->getString();
        Serial.println("Received response from the server: " + payload);

        JsonDocument doc;
        DeserializationError error = deserializeJson(doc, payload);

        if (!error) {
            bool serverLedState = doc[topic];
            if (serverLedState != relayState) {
                relayState = serverLedState;
                controlOutput();
            }
        } else {
            Serial.println("Failed to parse JSON data.");
        }
    } else {
        Serial.printf("ailed to obtain status information: %d\n", httpCode);
    }

    http->end();
}

void controlOutput() {
    digitalWrite(LED, relayState ? LOW : HIGH);
    digitalWrite(RELAY, relayState ? HIGH : LOW);
    Serial.println(relayState ? "LED is on" : "LED is off");
    Serial.println(relayState ? "RELAY is on" : "RELAY is off");
}

void loop() {
    if (WiFi.status() == WL_CONNECTED) {
        HTTPClient http;
        receiveStatus(&http);
        sendStatus(&http);
    } else {
        Serial.println("Wi-Fi connection lost. Reconnection in progress...");
        WiFi.reconnect();
    }

    delay(1000);
}
