plugins {
    kotlin("plugin.serialization") version "1.9.10"
    alias(libs.plugins.kotlin.jvm)
    alias(libs.plugins.ktor)
    id("war")
}

group = "com.souza"
version = "0.0.1"

tasks.named<War>("war") {
    from(sourceSets.main.get().output)
}

tasks.processResources {
    duplicatesStrategy = DuplicatesStrategy.EXCLUDE
}

sourceSets {
    main {
        resources.srcDirs("src/main/resources")
    }
}

repositories {
    mavenCentral()
}

dependencies {
    // Logging
    implementation("ch.qos.logback:logback-classic:1.4.14")

    // JakartaEE
    implementation("io.ktor:ktor-server-servlet-jakarta")

    // Suporte para IP remoto via headers
    implementation("io.ktor:ktor-server-forwarded-header")

    // Ktor core & servidor Tomcat
    implementation(libs.ktor.server.core)
    implementation(libs.ktor.server.tomcat.jakarta)
    implementation(libs.ktor.server.config.yaml)

    // Plugins Ktor
    implementation("io.ktor:ktor-server-call-logging")
    implementation("io.ktor:ktor-server-content-negotiation")
    implementation("io.ktor:ktor-serialization-kotlinx-json")

    // Testes
    testImplementation(libs.ktor.server.test.host)
    testImplementation(libs.kotlin.test.junit)
}
