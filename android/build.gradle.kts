allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Force stable CameraX and concurrent-futures
subprojects {
    configurations.all {
        resolutionStrategy {
            force("androidx.concurrent:concurrent-futures:1.1.0")
            force("androidx.camera:camera-core:1.3.3")
            force("androidx.camera:camera-camera2:1.3.3")
            force("androidx.camera:camera-lifecycle:1.3.3")
            force("androidx.camera:camera-view:1.3.3")
            force("androidx.camera:camera-extensions:1.3.3")
        }
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
