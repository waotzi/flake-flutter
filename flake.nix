{
  description = "A flake to manage a flutter-development-environment";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-22.05";

    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    devshell = {
      url = "github:numtide/devshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    android = {
      url = "github:tadfisher/android-nixpkgs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-dart = {
      url = "github:tadfisher/nix-dart";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvfetcher = {
      url    = "github:berberman/nvfetcher";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = { android
  , devshell
  , flake-utils
  , nix-dart
  , nixpkgs
  , nvfetcher
  , self
  }:

  {
    overlay = final: prev: {
      inherit (self.packages.${final.system}) android-sdk android-studio;
    };
  } //
  # flake-utils.lib.eachSystem [ "x86_64-linux" ] (system:
  flake-utils.lib.eachDefaultSystem (system:
  let
    pkgs = import nixpkgs {
      inherit system;
      config = {

        android_sdk.accept_license = true;
        allowUnfree = true;
      };
      overlays = [
        devshell.overlay
        self.overlay
      ];
    };

    nv-sources = pkgs.callPackage (import ./_sources/generated.nix) {};
  in rec
  {
    packages = {
      android-sdk = android.sdk.${system} (sdkPkgs: with sdkPkgs; [
        build-tools-30-0-3
        cmdline-tools-latest
        emulator
        platform-tools
        platforms-android-30
        platforms-android-31

        # sources-android-30
        # system-images-android-30-google-apis-x86
        # system-images-android-30-google-apis-playstore-x86
      ]);

      android-studio = pkgs.androidStudioPackages.stable;
      # android-studio = pkgs.androidStudioPackages.beta;
      # android-studio = pkgs.androidStudioPackages.preview;
      # android-studio = pkgs.androidStudioPackage.canary;
    };

    ### DART
    dart = (pkgs.callPackage ./nix/development/interpreters/dart/default.nix {
      inherit (nv-sources.dart) src version;
    });

    ### FLUTTER
    inherit (pkgs.callPackage ./nix/development/compilers/flutter/default.nix {
      inherit dart;
      inherit (nv-sources.flutter) src version;
    }) flutter;


    devShell = import ./devshell.nix { inherit dart flutter pkgs; };


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
