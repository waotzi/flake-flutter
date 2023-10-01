# flutter-flake
a flake for flutter-projects on nixos

## USAGE
cf. [SETUP](./template/README.org)

## INFO

### version
Tags relate to the flutter-version in `major.minor.patch`.
The optional flakeVersion is appended: `major.minor.patch.flakeVersion`.
A buildNumber (+N) cannot be used because of `nix flake` restrictions.

### update-workflow
- update devshell.nix
- update `changelog.md`
- commit
- tag (name: flutter version)
- push

## Android
Make sure the buildToolsVersion is compatible with the gradle version used in the flutter android folder. You can define the compiledSdkVersion and buildToolsVersion in the root build.gradle file:

*/build.gradle*
```
ext {
    compileSdkVersion = 33
    buildToolsVersion = "31.0.0"
}
```

You can then use the newley defined variables in your app/build.gradle file:

*/app/build.gradle*
```
android {
    compileSdkVersion rootProject.ext.compileSdkVersion
    buildToolsVersion rootProject.ext.buildToolsVersion
    ...
}
```

And lastly to make sure all third party extensions are using the same buildtool you can add again to the root build.gradle file this section:

*/build.gradle*
```
subprojects {
    afterEvaluate {project ->
        if (project.hasProperty("android")) {
            android {
                compileSdkVersion rootProject.ext.compileSdkVersion
                buildToolsVersion rootProject.ext.buildToolsVersion
            }
        }
    }
}
```
