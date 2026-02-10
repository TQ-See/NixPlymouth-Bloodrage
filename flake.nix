{
  description = "Bloodrage NixOS Plymouth Theme";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, flake-utils, ... }:
    with flake-utils.lib; eachDefaultSystem (system: let
      pkgs = import nixpkgs {
        inherit system;
      };
    in {
      packages = {
        default = pkgs.callPackage ./package.nix {};
        Bloodrage-plymouth = pkgs.callPackage ./package.nix {};
      };

      devShells.default = pkgs.mkShell {
        name = "plymouth-test";
        packages = with pkgs; [
          plymouth
          (pkgs.writeShellScriptBin "show" (builtins.readFile ./show-splash.sh))
        ];
      };
    })
    // {
      overlays.default = final: prev: {
        Bloodrage-plymouth = final.callPackage ./package.nix {};
      };
    };
}
