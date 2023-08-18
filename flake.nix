{
  description = "A flake to manage a flutter-development-environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    devshell = {
      url = "github:numtide/devshell";
    };

  };

  
  outputs = { self, nixpkgs, flake-utils, devshell }:
  flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs {
        inherit system;
        config = {
          android_sdk.accept_license = true;
          allowUnfree = true;
        };
      };
    in rec
    {
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
