{ pkgs }:

with pkgs;
devshell.mkShell {
  name = "greenery";
  motd = ''
    Entered the Android app development environment.
  '';
  env = let
    javaHome = jdk11.home;
  in [
    {
      name  = "ANDROID_HOME";
      value = "${android-sdk}/share/android-sdk";
    }
    {
      name  = "ANDROID_SDK_ROOT";
      value = "${android-sdk}/share/android-sdk";
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
      name  = "USE_CCACHE";
      value = 0;
    }
  ];
  packages = [
    android-studio
    android-sdk
    gradle
    jdk11
    pkg-config
    android-sdk
    clang
    cmake
    
    flutter37
    glib
    glib.dev
    google-chrome
    gtk3
    gtk3.dev
    lcov
    ninja
    nvfetcher
    pkgconfig
    sqlite
    sqlite-web

    nodePackages.firebase-tools

    sd
    fd
  ];
}
