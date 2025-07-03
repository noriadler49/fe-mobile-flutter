// ext {
//     set("compileSdkVersion", 35)
//     set("targetSdkVersion", 35)
//     set("minSdkVersion", 21)
// }
extra["compileSdkVersion"] = 35
extra["targetSdkVersion"] = 35
extra["minSdkVersion"] = 21

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
