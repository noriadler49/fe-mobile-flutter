<<<<<<< HEAD
// ext {
//     set("compileSdkVersion", 35)
//     set("targetSdkVersion", 35)
//     set("minSdkVersion", 21)
// }
extra["compileSdkVersion"] = 35
extra["targetSdkVersion"] = 35
extra["minSdkVersion"] = 21

=======
>>>>>>> fa09a65295c49b1edae43ba7d51002379a294e82
allprojects {
    repositories {
        google()
        mavenCentral()
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
