{
  description = "A flake to manage a flutter-development-environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
    flake-utils.inputs.nixpkgs-lib.follows = "nixpkgs";
    devshell.url = "github:numtide/devshell";
    devshell.inputs.nixpkgs.follows = "nixpkgs";
    android-nixpkgs.url = "github:tadfisher/android-nixpkgs/stable";
    android-nixpkgs.inputs.nixpkgs.follows = "nixpkgs";
    android-nixpkgs.inputs.devshell.follows = "devshell";
  };

  outputs = { android-nixpkgs, devshell, flake-utils, nixpkgs, self }:
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
        #permittedInsecurePackages = [
        #  "python-2.7.18.6"
        #];
      };
      overlays = [
        devshell.overlay
        self.overlay
      ];
    };

    #nv-sources = pkgs.callPackage (import ./_sources/generated.nix) {};
  in rec
  {
    packages = {
      android-sdk = android-nixpkgs.sdk.${system} (sdkPkgs: with sdkPkgs; [
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
    };

    devShell = import ./devshell.nix { inherit pkgs; };


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
