allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
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

// Fix for isar_flutter_libs and other plugins needing higher compileSdk
subprojects {
    val configureSdk = {
        val android = project.extensions.findByName("android")
        if (android != null) {
            try {
                // Force compileSdkVersion to 34 to avoid lStar errors
                val method = android.javaClass.getMethod("compileSdkVersion", Int::class.javaPrimitiveType)
                method.invoke(android, 34)
            } catch (e: Exception) {
                // Ignore
            }
        }
    }

    if (project.state.executed) {
        configureSdk()
    } else {
        afterEvaluate { configureSdk() }
    }
}

subprojects {
    val configureNamespace = {
        if (project.name == "isar_flutter_libs") {
            try {
                val android = project.extensions.findByName("android")
                if (android != null) {
                    val setNamespace = android.javaClass.getMethod("setNamespace", String::class.java)
                    setNamespace.invoke(android, "dev.isar.isar_flutter_libs")
                    println("Applied namespace workaround for isar_flutter_libs")
                }
            } catch (e: Exception) {
                println("Failed to apply namespace workaround: $e")
            }
        }
    }
    
    if (project.state.executed) {
        configureNamespace()
    } else {
        afterEvaluate { configureNamespace() }
    }
}
