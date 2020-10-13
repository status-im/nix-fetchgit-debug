{ pkgs ? import <nixpkgs> { } }:

pkgs.fetchgit {
  url = "https://github.com/status-im/nix-fetchgit-debug.git";
  rev = "162d1f6225257db5085d8abd57a6b5e14ae3aa59";
  sha256 = "03savn410wxmi3cw5977ssl3hnpdpgqpc3jn69jcd82m3ks01xbm";
  leaveDotGit = true;
  deepClone = true;
  fetchSubmodules = true;
}
