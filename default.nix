{ pkgs ? import <nixpkgs> { } }:

pkgs.fetchgit {
  url = "https://github.com/status-im/nix-fetchgit-debug.git";
  rev = "f0e389dab851fae1468715cf929288f736060529";
  sha256 = "0qmrg2a79ynjdwcw8jgkd0qdy880rwn366p78qr9yj7hrnznpzci";
  leaveDotGit = true;
  deepClone = true;
  fetchSubmodules = true;
}
