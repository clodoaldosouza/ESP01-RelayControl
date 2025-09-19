package com.souza

import io.ktor.server.application.*

fun main(args: Array<String>) {
    io.ktor.server.tomcat.jakarta.EngineMain.main(args)
}

fun Application.module() {
    log.info("Modules init")
    configurePlugins()
    configureRouting()
}
