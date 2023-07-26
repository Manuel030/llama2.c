{
  description = "llama2.c dev shell";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:

    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShell = pkgs.mkShell {
          packages = [
            pkgs.gcc
            pkgs.wget
            pkgs.clang
            pkgs.glibc_multi
            pkgs.pkgsCross.aarch64-multiplatform.binutils
            (pkgs.python311.withPackages (ps: with ps; [
              virtualenv
              pip
            ]))
          ];
          shellHook = ''
            export ANDROID_HOME="/home/manuel/Android/Sdk"
            export NDK_HOME="/home/manuel/Android/Sdk/ndk/25.2.9519653"
            export CLANG_PATH="${pkgs.clang}"
          '';
          LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [
            # pkgs.pkgsCross.aarch64-multiplatform.binutils
            # pkgs.glibc_multi
          ];
        };
      }
    );
}
