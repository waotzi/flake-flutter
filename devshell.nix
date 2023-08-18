{ pkgs, androidSdk, androidComposition, buildToolsVersion }:

with pkgs;
devshell.mkShell {
  name = "flutter";
  motd = ''
    Entered the Android app development environment.
  '';
 env = let
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

