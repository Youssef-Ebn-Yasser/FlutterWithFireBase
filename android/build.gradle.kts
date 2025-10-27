// android/build.gradle.kts (Project-level)

import org.gradle.api.tasks.Delete
import org.gradle.kotlin.dsl.*

// Declare repositories for all projects
allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Redirect build directories (optional, based on your original setup)
val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

// Make sure subprojects evaluate after :app
subprojects {
    project.evaluationDependsOn(":app")
}

// Clean task
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

// Plugins for project-level only (do NOT apply here)
plugins {
    id("com.android.application") apply false
    id("com.android.library") apply false
    id("org.jetbrains.kotlin.android") apply false
    id("com.google.gms.google-services") version "4.4.4" apply false
}
