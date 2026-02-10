{
  description = "Bloodrage NixOS Plymouth Theme";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs { inherit system; };
    in {
      packages = rec {
        Bloodrage-plymouth = pkgs.callPackage ./package.nix {
          theme = "Bloodrage";
          bgColor = "0, 0, 0"; # Sesuaikan jika ingin warna lain
        };
        default = Bloodrage-plymouth;
      };

      devShells.default = pkgs.mkShell {
        name = "plymouth-test";
        packages = with pkgs; [
          plymouth
          (pkgs.writeShellScriptBin "show" (builtins.readFile ./show-splash.sh))
        ];
      };
    }) // {
      # Overlay agar bisa dipakai di configuration.nix dengan mudah
      overlays.default = final: prev: {
        Bloodrage-plymouth = final.callPackage ./package.nix { };
      };
    };
}
