{ nixpkgs ? import <nixpkgs> {}, compiler ? "default" }:
let
  inherit (nixpkgs) pkgs;
  haskellPackages = if compiler == "default"
                       then pkgs.haskellPackages
                       else pkgs.haskell.packages.${compiler};

  modifiedHaskellPackages = haskellPackages.override {
    overrides = self: super: {
      hedgehog       = self.callHackage "hedgehog" "0.6" {};
      tasty-hedgehog = self.callHackage "tasty-hedgehog" "0.2.0.0" {};
      polyparse = self.callHackage "polyparse" "1.12.1" {};
      concurrent-output = pkgs.haskell.lib.doJailbreak super.concurrent-output;
    };
  };

  exitcode = modifiedHaskellPackages.callPackage ./exitcode.nix {};
in
  exitcode
