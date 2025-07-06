pluginManagement {
    val flutterSdkPath = runCatching {
        val properties = java.util.Properties()
        file("local.properties").inputStream().use { properties.load(it) }
        properties.getProperty("flutter.sdk")?.let { path ->
            require(path.isNotEmpty()) { "flutter.sdk is empty in local.properties" }
            path
        } ?: throw IllegalStateException("flutter.sdk not set in local.properties")
    }.getOrElse {
        println("Warning: Could not load local.properties, falling back to default Flutter SDK path.")
        System.getenv("FLUTTER_ROOT") ?: "C:\\Users\\Admin\\dev\\flutter" // Fallback path
    }

    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    id("com.android.application") version "8.7.3" apply false
    id("org.jetbrains.kotlin.android") version "2.1.0" apply false
}

include(":app")
