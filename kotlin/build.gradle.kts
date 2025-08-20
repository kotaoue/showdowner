plugins {
    kotlin("jvm") version "1.9.10"
    kotlin("plugin.serialization") version "1.9.10"
    application
}

group = "com.benchmark"
version = "1.0.0"

repositories {
    mavenCentral()
}

dependencies {
    implementation("org.jetbrains.kotlinx:kotlinx-serialization-json:1.6.0")
    implementation("org.jetbrains.kotlin:kotlin-stdlib-jdk8")
}

application {
    mainClass.set("com.benchmark.MainKt")
}

kotlin {
    jvmToolchain(11)
}

tasks.jar {
    manifest {
        attributes["Main-Class"] = "com.benchmark.MainKt"
    }
    configurations["compileClasspath"].forEach { file: File ->
        from(zipTree(file.absolutePath))
    }
    duplicatesStrategy = DuplicatesStrategy.INCLUDE
}