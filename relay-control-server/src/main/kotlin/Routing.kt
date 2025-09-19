package com.souza

import io.ktor.http.*
import io.ktor.serialization.kotlinx.json.*
import io.ktor.server.application.*
import io.ktor.server.plugins.*
import io.ktor.server.plugins.calllogging.*
import io.ktor.server.plugins.contentnegotiation.*
import io.ktor.server.request.*
import io.ktor.server.response.*
import io.ktor.server.routing.*
import kotlinx.serialization.Serializable
import kotlinx.serialization.json.Json

var relayState: Boolean = false
private const val RELAY = "relay"

@Serializable
data class RelayRequest(val relay: Boolean? = null)

fun Application.configurePlugins() {
    install(CallLogging)
    install(ContentNegotiation) {
        json(Json {
            ignoreUnknownKeys = true
            prettyPrint = true
        })
    }
}

fun Application.configureRouting() {
    routing {
        get("/status") {
            val clientIp = call.request.origin.remoteHost
            log.info("[$clientIp] GET /status request received")
            call.respond(mapOf(RELAY to relayState))
        }

        post("/update") {
            val clientIp = call.request.origin.remoteHost
            log.info("[$clientIp] POST /update request received")

            val body = call.receive<RelayRequest>()
            val relay = body.relay ?: run {
                log.warn("[$clientIp] Error: Invalid format received at /update")
                call.respond(HttpStatusCode.BadRequest, mapOf("error" to "Invalid format"))
                return@post
            }

            relayState = relay
            val state = if (relayState) "on" else "off"
            log.info("[$clientIp] Relay switched to: $state")

            call.respond(mapOf("success" to true, RELAY to relayState))
        }
    }
}
