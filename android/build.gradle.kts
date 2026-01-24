import org.gradle.api.tasks.Delete
import org.gradle.api.file.Directory

buildscript {
    val kotlin_version = "1.9.10" // Stable Kotlin
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath("com.android.tools.build:gradle:8.1.2")
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version")
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Centralized build directory
val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

// Ensure all subprojects evaluate after :app
subprojects {
    project.evaluationDependsOn(":app")
}

// Safe clean task
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

// Stop Gradle daemon before building (prevent incremental cache issues)
gradle.taskGraph.whenReady {
    gradle.startParameter.isOffline = false
}
