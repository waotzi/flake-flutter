{ pkgs }:

with pkgs;
devshell.mkShell {
  name = "greenery";
  motd = ''
    Entered the Android app development environment.
  '';
 env = let
  androidComposition = androidenv.composeAndroidPackages {
  toolsVersion = "26.1.1";
    platformToolsVersion = "33.0.3";
    buildToolsVersions = [ buildToolsVersion ];
    includeEmulator = false;
    emulatorVersion = "31.3.10";
    platformVersions = [ "33" ];
    includeSources = false;
    includeSystemImages = false;
    systemImageTypes = [ "google_apis_playstore" ];
    abiVersions = [ "armeabi-v7a" "arm64-v8a" ];
    includeNDK = true;
    ndkVersions = [ "22.0.7026061" ];
    useGoogleAPIs = false;
    useGoogleTVAddOns = false;
  };
  androidSdk = androidComposition.androidsdk;
  buildToolsVersion = "31.0.0";
  javaHome = jdk11.home;
 in [
    {
      name  = "ANDROID_HOME";
      value = "${androidSdk}/libexec/android-sdk";
    }
    {
      name  = "ANDROID_SDK_ROOT";
      value = "${androidSdk}/libexec/android-sdk";
    }
    {
      name  = "JAVA_HOME";
      value = javaHome;
    }
    {
      name  = "ANDROID_JAVA_HOME";
      value = javaHome;
    }
    {
      name  = "CHROME_EXECUTABLE";
      value = "${google-chrome}/bin/google-chrome-stable";
    }
    {
      name  = "FLUTTER_SDK";
      value = "${flutter}";
    }
    {
      name  = "DART";
      value = "${flutter}/bin/cache/dart-sdk/bin/dart";
    }
    {
      name  = "FLUTTER_ROOT";
      value = "${flutter}";
    }

    {
      name  = "DART_SDK_PATH";
      value = "${flutter}/bin/cache/dart-sdk";
    }
    {
      name  = "DART_SDK";
      value = "${flutter}/bin/cache/dart-sdk";
    }
    {
      name  = "GRADLE_OPTS";
      value = "-Dorg.gradle.project.android.aapt2FromMavenOverride=${androidSdk}/libexec/android-sdk/build-tools/${buildToolsVersion}/aapt2";
    }
  ];
  packages = [
    androidComposition.platform-tools
    androidSdk
    gradle
    jdk11
    pkg-config
    clang
    cmake
    flutter
    glib
    glib.dev
    google-chrome
    gtk3
    gtk3.dev
    lcov
    ninja
    pkgconfig
    sqlite
    sqlite-web
    nodePackages.firebase-tools
    sd
    fd
  ];
}

