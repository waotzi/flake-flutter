# flutterFlake
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
- update `changelog.org`
- commit
- tag (name: flutter version)
- push

## Android
Make sure the buildToolsVersion is compatible with the gradle version used in the flutter android folder. Specify in the project android/app/build.gradle file the specific buildToolsVersion like so:
```
android {
    namespace "com.example.inner_breeze"
    compileSdkVersion 33
    buildToolsVersion "31.0.0" // add this line
    ...
}
```

## TODO TODOS

### TODO use app
### TODO enable `linux` builds
currently gtk3-dev-libs cannot be found
### TODO do not use `~/.cache/flutter`
### TODO emulator

## DONE ERLEDIGTES

### DONE flake-template
### DONE update-workflow
