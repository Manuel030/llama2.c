{
  description = "android port llama2.c";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    devshell.url = "github:numtide/devshell";
    flake-utils.url = "github:numtide/flake-utils";
    android.url = "github:tadfisher/android-nixpkgs";
  };

  outputs = { self, nixpkgs, devshell, flake-utils, android }:
    {
      overlay = final: prev: {
        inherit (self.packages.${final.system}) android-sdk android-studio;
      };
    }
    //
    flake-utils.lib.eachSystem [ "x86_64-linux" ] (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          overlays = [
            devshell.overlays.default
            self.overlay
          ];
        };
      in
      {
        packages = {
          android-sdk = android.sdk.${system} (sdkPkgs: with sdkPkgs; [
            build-tools-30-0-2
            cmdline-tools-latest
            emulator
            platform-tools
            platforms-android-3
            ndk-bundle
          ]);

          android-studio = pkgs.androidStudioPackages.stable;
          gcc = pkgs.gcc;
          wget = pkgs.wget;
        };

        devShell = import ./devshell.nix { inherit pkgs; };
      }
    );
}
