# nix-crystals

An **_experimental, work-in-progress_** framework for building Nix flakes. Flakes are built by autodiscovering
"crystals" in your project, which are NixOS modules in files named `crystal.nix`.

This is in a proof of concept phase and is basically unusable. The goal is to make maintaining larger flake projects
(like corporate monorepos) less cumbersome, though, I believe the use of the NixOS module system might help cleanup
`flake.nix` on smaller projects, as well.

The name is based on the idea that it takes a bunch of crystals to form a snowflake.

## Example

### Multi-file

In large projects, you may want to break up your flake into smaller files. You can use "assembleFrom" to automatically
assemble the flake from all the crystal files in your project (which should be named `crystal.nix`).

`flake.nix`
```nix
{
  inputs = {
    crystals.url = "github:tristanpemble/nix-crystals";
    nixpkgs = {};
  };

  outputs = inputs: inputs.crystals.assembleFrom {
    inherit inputs;
    root = ./.;
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


### Single-file

In a smaller, more standard flakes that have a small number of packages, you can skip the crystals and just use the
module system directly. This might be helpful if you to avoid dealing with nixpkgs and the mildly annoying system maps
that can create a verbose `flake.nix`. The result looks like this:

`flake.nix`
```nix
{
  inputs = {
    crystals.url = "github:tristanpemble/nix-crystals";
    nixpkgs = {};
  };

  outputs = inputs: inputs.crystals.lib.mkFlake {
    inherit inputs;
    packages.default = ./.;
    overlays.default = final: prev: {
      my-app = final.callPackage ./. {};
    };
  };
}
```

`default.nix`
```nix
{ runCommand }:

runCommand "package-a" {} ''
  echo "Hello, world!" > $out
''
```
