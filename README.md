# nix-crystals

An **_experimental, work-in-progress_** framework for building Nix flakes. Flakes are built by autodiscovering
"crystals" in your project, which are NixOS modules in files named `crystal.nix`.

This is in a proof of concept phase and is basically unusable. The goal is to make maintaining larger flake projects
(like corporate monorepos) less cumbersome, though, I believe the use of the NixOS module system might help cleanup
`flake.nix` on smaller projects, as well.

The name is based on the idea that it takes a bunch of crystals to form a snowflake.

## Example

### Multi-file

In large projects, you may want to break up your flake into smaller files. You can use the "discoverCrystals" to
automatically find files named `crystal.nix`, and then import them:

`flake.nix`
```nix
{
  inputs = {
    crystals.url = "github:tristanpemble/nix-crystals";
    nixpkgs = {};
  };

  outputs = inputs: with inputs.crystals.lib;
    let imports = discoverCrystals ./.;
    in mkFlake { inherit imports inputs; };
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

In a smaller, more standard flakes with a small number of packages, you might use this to avoid dealing with nixpkgs and
the mildly annoying system maps:

`flake.nix`
```nix
{
  inputs = {
    crystals.url = "github:tristanpemble/nix-crystals";
    nixpkgs = {};
  };

  outputs = inputs: inputs.crystals.lib.mkFlake ({ config, ... }: {
    inherit inputs;
    packages.default = config.packages.package-a;
    packages.package-a =
      { runCommand }:
      runCommand "package-a" {} ''
        echo "Hello, world!" > $out
      '';

    packages.macos-only =
      { lib, runCommand, stdenv }:
      lib.mkIf stdenv.isDarwin (runCommand "my-macos-package" {} ''
        echo "Hello, darwin!" > $out
      '');
  });
}
```
