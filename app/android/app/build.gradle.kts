import java.util.Properties

plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Release signing: android/key.properties (local) or env vars (CI), never in git.
val keyProps = Properties().apply {
    val f = rootProject.file("key.properties")
    if (f.exists()) f.inputStream().use { load(it) }
}
fun signingValue(name: String, env: String): String? = keyProps.getProperty(name) ?: System.getenv(env)

android {
    namespace = "at.macrobandit.shopbandit"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        // needed by flutter_local_notifications
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        applicationId = "at.macrobandit.shopbandit"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        // Uses the version code from pubspec.yaml. When using split APKs, 1000 * ABI_VERSION
        // is added automatically by Flutter. (https://developer.android.com/studio/build/configure-apk-splits#configure-APK-versions)
        // You can force using the value of versionCode by specifying the `-P force-version-code-ignoring-abi=true`
        // flag during build.
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            val store = signingValue("storeFile", "SHOPBANDIT_KEYSTORE")
            if (store != null) {
                storeFile = file(store)
                storePassword = signingValue("storePassword", "SHOPBANDIT_KEYSTORE_PASSWORD")
                keyAlias = signingValue("keyAlias", "SHOPBANDIT_KEY_ALIAS")
                keyPassword = signingValue("keyPassword", "SHOPBANDIT_KEY_PASSWORD")
            }
        }
    }

    buildTypes {
        release {
            // unsigned when no keystore is configured (e.g. F-Droid signs itself)
            val release = signingConfigs.getByName("release")
            signingConfig = if (release.storeFile != null) release else null
        }
    }

    dependenciesInfo {
        // F-Droid: no Google-encrypted dependency metadata blob in the APK
        includeInApk = false
        includeInBundle = false
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}

// UnifiedPush connector depends on tink (JVM), flutter_secure_storage on
// tink-android: same classes, so use only the Android flavour.
configurations.all {
    resolutionStrategy.dependencySubstitution {
        substitute(module("com.google.crypto.tink:tink")).using(module("com.google.crypto.tink:tink-android:1.23.0"))
    }
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")
}
