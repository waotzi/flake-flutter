{
  description = "A flake to manage a flutter-development-environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils }:
  flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs {
        inherit system;
        config = {
          android_sdk.accept_license = true;
          allowUnfree = true;
        };
        overlays = [ self.overlay ];
      };
      buildToolsVersion = "31.0.0";

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
    in
    {


      devShell = 
        with pkgs; mkShell rec {
          ANDROID_HOME = "${androidSdk}/libexec/android-sdk";
          ANDROID_SDK_ROOT = "${androidSdk}/libexec/android-sdk";
          JAVA_HOME = jdk11;
          CHROME_EXECUTABLE = "${google-chrome}/bin/google-chrome-stable";
          FLUTTER_SDK = "${flutter}";
          GRADLE_OPTS="-Dorg.gradle.project.android.aapt2FromMavenOverride=${androidSdk}/libexec/android-sdk/build-tools/${buildToolsVersion}/aapt2";
          buildInputs = [
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
        };
    }) // {
      templates = {
        flutter = {
          path        = ./template;
          description = "A flutter development environment";
        };
      };
      defaultTemplate = self.templates.flutter;
    };
}
