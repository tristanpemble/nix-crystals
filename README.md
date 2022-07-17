# nix-crystals

An **_experimental, highly work-in-progress_** framework for building Nix flakes. Flakes are built by autodiscovering
"crystals" in your project, which are NixOS modules in files named `crystal.nix`.

This is in a proof of concept phase and is basically unusable. The goal is to make maintaining larger flake projects
(like corporate monorepos) less cumbersome, though, I believe the use of the NixOS module system might help cleanup
`flake.nix` on smaller projects, as well.

The name is based on the idea that it takes a bunch of crystals to form a snowflake.

## Example

`flake.nix`
```nix
{
  inputs = {
    crystals.url = "github:tristanpemble/nix-crystals";
    nixpkgs = {};
  };

  outputs = { crystals, ... }@inputs: with crystals.lib;
    mkFlake {
      inherit inputs;
      imports = discoverCrystals ./.;
    };
}
```

`./package-a/crystal.nix`
```
{ config, ... }:

{
  packages.default = config.packages.package-a;
  packages.package-a = { runCommand }: runCommand "package-a" {} ''
    echo "Hello, world!" > $out
  '';
}
```
