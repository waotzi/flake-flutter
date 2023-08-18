{ pkgs }:

let
  androidComposition = pkgs.androidenv.composeAndroidPackages {
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
in
{
  name = "flutter-development-environment";
  packages = with pkgs; [
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

  env = {
    ANDROID_HOME = "${androidSdk}/libexec/android-sdk";
    ANDROID_SDK_ROOT = "${androidSdk}/libexec/android-sdk";
    JAVA_HOME = jdk11.home;
    CHROME_EXECUTABLE = "${google-chrome}/bin/google-chrome-stable";
    FLUTTER_SDK = "${flutter}";
    GRADLE_OPTS="-Dorg.gradle.project.android.aapt2FromMavenOverride=${androidSdk}/libexec/android-sdk/build-tools/${buildToolsVersion}/aapt2";
  };
}
