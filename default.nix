{ pkgs ? import <nixpkgs> { } }:

pkgs.fetchgit {
  url = "https://github.com/status-im/nix-fetchgit-debug.git";
  rev = "f0e389dab851fae1468715cf929288f736060529";
  sha256 = "09d40rnqx61354clac1ky8caha2w155jm8637d4mhyx7vdknjrkr";
  deepClone = true;
  fetchSubmodules = true;
}
