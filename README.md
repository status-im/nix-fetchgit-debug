# Description

This repo exists to reproduce an issue with fetching some git submodules which breaks determinism of `pkgs.fetchgit`.

The issue appears only when using both `fetchSubmodules = true` and `deepClone = true`.

# Reproduction

When I build the `default.nix` derivation which fetches the source for this repo using `pkgs.fetchgit` I get different resulting `sha256` at differnt times:
```
hash mismatch in fixed-output derivation '/nix/store/lyis1l5zbsi9kfhlsg16pqxs12y518jn-nix-fetchgit-debug-f0e389d':
  wanted: sha256:0qmrg2a79ynjdwcw8jgkd0qdy880rwn366p78qr9yj7hrnznpzci
  got:    sha256:0brc139p24m1b4hrxkkcra5fjlv8dl1662a9r355jlhpp41km033
error: build of '/nix/store/zz6cbs4440yiqdb007ddq7yldkzwgd38-nix-fetchgit-debug-f0e389d.drv' failed
```
This seems to be caused by differences in [Git Packfiles](https://git-scm.com/book/en/v2/Git-Internals-Packfiles) when comparing results of the derivation built multiple times:
```
 > diff -r \
     /nix/store/lyis1l5zbsi9kfhlsg16pqxs12y518jn-nix-fetchgit-debug-f0e389d \
     /nix/store/9vylzwxxi52bvyr8dcrsaaxj5ppwrid2-nix-fetchgit-debug-f0e389d

diff -r /nix/store/lyis1l5zbsi9kfhlsg16pqxs12y518jn-nix-fetchgit-debug-f0e389d/nim-faststreams/.git/objects/info/packs /nix/store/9vylzwxxi52bvyr8dcrsaaxj5ppwrid2-nix-fetchgit-debug-f0e389d/nim-faststreams/.git/objects/info/packs
1c1
< P pack-2a516976bb18daa498c8296b7de9c3bca3a61dba.pack
---
> P pack-348a1af74c1229307cad55ddc9af3b06f4496d20.pack
Only in /nix/store/lyis1l5zbsi9kfhlsg16pqxs12y518jn-nix-fetchgit-debug-f0e389d/nim-faststreams/.git/objects/pack: pack-2a516976bb18daa498c8296b7de9c3bca3a61dba.idx
Only in /nix/store/lyis1l5zbsi9kfhlsg16pqxs12y518jn-nix-fetchgit-debug-f0e389d/nim-faststreams/.git/objects/pack: pack-2a516976bb18daa498c8296b7de9c3bca3a61dba.pack
Only in /nix/store/9vylzwxxi52bvyr8dcrsaaxj5ppwrid2-nix-fetchgit-debug-f0e389d/nim-faststreams/.git/objects/pack: pack-348a1af74c1229307cad55ddc9af3b06f4496d20.idx
Only in /nix/store/9vylzwxxi52bvyr8dcrsaaxj5ppwrid2-nix-fetchgit-debug-f0e389d/nim-faststreams/.git/objects/pack: pack-348a1af74c1229307cad55ddc9af3b06f4496d20.pack
diff -r /nix/store/lyis1l5zbsi9kfhlsg16pqxs12y518jn-nix-fetchgit-debug-f0e389d/nim-waku/vendor/nim-faststreams/.git/objects/info/packs /nix/store/9vylzwxxi52bvyr8dcrsaaxj5ppwrid2-nix-fetchgit-debug-f0e389d/nim-waku/vendor/nim-faststreams/.git/objects/info/packs
1c1
< P pack-7a7a30973ad008980ac4954722689eb55b1941df.pack
---
> P pack-b56d89b8eafd21f484dc6af50a7771bbf28ed92c.pack
Only in /nix/store/lyis1l5zbsi9kfhlsg16pqxs12y518jn-nix-fetchgit-debug-f0e389d/nim-waku/vendor/nim-faststreams/.git/objects/pack: pack-7a7a30973ad008980ac4954722689eb55b1941df.idx
Only in /nix/store/lyis1l5zbsi9kfhlsg16pqxs12y518jn-nix-fetchgit-debug-f0e389d/nim-waku/vendor/nim-faststreams/.git/objects/pack: pack-7a7a30973ad008980ac4954722689eb55b1941df.pack
Only in /nix/store/9vylzwxxi52bvyr8dcrsaaxj5ppwrid2-nix-fetchgit-debug-f0e389d/nim-waku/vendor/nim-faststreams/.git/objects/pack: pack-b56d89b8eafd21f484dc6af50a7771bbf28ed92c.idx
Only in /nix/store/9vylzwxxi52bvyr8dcrsaaxj5ppwrid2-nix-fetchgit-debug-f0e389d/nim-waku/vendor/nim-faststreams/.git/objects/pack: pack-b56d89b8eafd21f484dc6af50a7771bbf28ed92c.pack
```
The cause of this seems to be the fact that both the root repo and the `nim-waku` submodule reference the same `nim-faststreams` repo. Also both this repo and `nim-waku` use the same `nim-faststreams` commit: [`5df69fc6`](https://github.com/status-im/nim-faststreams/commit/5df69fc6961e58205189cd92ae2477769fa8c4c0).

# Issue

Opened an issue for this: https://github.com/NixOS/nixpkgs/issues/100498
