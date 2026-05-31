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

    // Patch Namespace reattiva all'aggiunta dei plugin Android (Risolve bug isar_flutter_libs)
    project.plugins.whenPluginAdded {
        if (this.javaClass.name.contains("AndroidBasePlugin") || 
            this.javaClass.name.contains("LibraryPlugin") || 
            this.javaClass.name.contains("AppPlugin")) {
            
            val android = project.extensions.findByName("android")
            if (android != null) {
                val namespaceProperty = android.javaClass.methods.firstOrNull { it.name == "getNamespace" }
                val setNamespaceMethod = android.javaClass.methods.firstOrNull { it.name == "setNamespace" && it.parameterTypes.size == 1 && it.parameterTypes[0] == String::class.java }
                
                if (namespaceProperty != null && setNamespaceMethod != null) {
                    val currentNamespace = namespaceProperty.invoke(android)
                    if (currentNamespace == null) {
                        val fallbackNamespace = "com.codepulse.guido.${project.name.replace("-", "_")}"
                        setNamespaceMethod.invoke(android, fallbackNamespace)
                        logger.quiet("[GradlePatch] Forced namespace for subproject ${project.name} -> $fallbackNamespace")
                    }
                }
            }
        }
    }
}

subprojects {
    afterEvaluate {
        val android = project.extensions.findByName("android")
        if (android != null) {
            val compileSdkMethod = android.javaClass.methods.firstOrNull { 
                (it.name == "compileSdk" || it.name == "setCompileSdk" || it.name == "setCompileSdkVersion") && 
                it.parameterTypes.size == 1 && 
                (it.parameterTypes[0] == Int::class.java || it.parameterTypes[0] == String::class.java || it.parameterTypes[0] == java.lang.Integer.TYPE)
            }
            if (compileSdkMethod != null) {
                try {
                    if (compileSdkMethod.parameterTypes[0] == String::class.java) {
                        compileSdkMethod.invoke(android, "android-36")
                    } else {
                        compileSdkMethod.invoke(android, 36)
                    }
                    logger.quiet("[GradlePatch] Forced compileSdk=36 for subproject ${project.name}")
                } catch (e: Exception) {
                    logger.quiet("[GradlePatch] Failed forcing compileSdk for subproject ${project.name}: ${e.message}")
                }
            }
        }
    }
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
