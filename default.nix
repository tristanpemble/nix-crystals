{ lib, ... }:

let
  # The list of systems supported by nixpkgs and hydra
  defaultSystems = [
    "aarch64-linux"
    "aarch64-darwin"
    "i686-linux"
    "x86_64-darwin"
    "x86_64-linux"
  ];

  # List of all systems defined in nixpkgs
  # Keep in sync with nixpkgs with the following command:
  # $ nix-instantiate --json --eval --expr "with import <nixpkgs> {}; lib.platforms.all" | jq 'sort' | sed 's!,!!'
  allSystems = [
    "aarch64-darwin"
    "aarch64-genode"
    "aarch64-linux"
    "aarch64-netbsd"
    "aarch64-none"
    "aarch64_be-none"
    "arm-none"
    "armv5tel-linux"
    "armv6l-linux"
    "armv6l-netbsd"
    "armv6l-none"
    "armv7a-darwin"
    "armv7a-linux"
    "armv7a-netbsd"
    "armv7l-linux"
    "armv7l-netbsd"
    "avr-none"
    "i686-cygwin"
    "i686-darwin"
    "i686-freebsd"
    "i686-genode"
    "i686-linux"
    "i686-netbsd"
    "i686-none"
    "i686-openbsd"
    "i686-windows"
    "js-ghcjs"
    "m68k-linux"
    "m68k-netbsd"
    "m68k-none"
    "mips64el-linux"
    "mipsel-linux"
    "mipsel-netbsd"
    "mmix-mmixware"
    "msp430-none"
    "or1k-none"
    "powerpc-netbsd"
    "powerpc-none"
    "powerpc64-linux"
    "powerpc64le-linux"
    "powerpcle-none"
    "riscv32-linux"
    "riscv32-netbsd"
    "riscv32-none"
    "riscv64-linux"
    "riscv64-netbsd"
    "riscv64-none"
    "s390-linux"
    "s390-none"
    "s390x-linux"
    "s390x-none"
    "vc4-none"
    "wasm32-wasi"
    "wasm64-wasi"
    "x86_64-cygwin"
    "x86_64-darwin"
    "x86_64-freebsd"
    "x86_64-genode"
    "x86_64-linux"
    "x86_64-netbsd"
    "x86_64-none"
    "x86_64-openbsd"
    "x86_64-redox"
    "x86_64-solaris"
    "x86_64-windows"
  ];

  filterCrystals = path: builtins.path {
    name = "source";
    inherit path;
    filter = path: type: type != "regular" || baseNameOf path == "crystal.nix";
  };

  reduceCrystals = prefix: path: lib.mapAttrsToList (name: type:
    if type == "regular"
    then [ "${prefix}/${name}" ]
    else if type == "directory"
    then reduceCrystals "${prefix}/${name}" "${path}/${name}"
    else []
  ) (builtins.readDir path);

  discoverCrystals = paths:
    lib.flatten (map (root:
      reduceCrystals "${root}" (filterCrystals root)
    ) (lib.toList paths));

  evalCrystals = crystals:
    lib.evalModules {
      specialArgs.lib = lib // {
        inherit allSystems defaultSystems;
      };
      modules = [
        ./modules
      ] ++ (lib.toList crystals);
    };

  mkFlake = crystals:
    let eval = evalCrystals crystals;
    in eval.config.outputs;

  assembleFrom = { inputs, root, configuration ? {} }:
    let imports = discoverCrystals root;
    in mkFlake [ { inherit imports inputs; } configuration ];
in {
  lib = {
    inherit assembleFrom discoverCrystals evalCrystals mkFlake;
  };
  outputs = {
    inherit assembleFrom;
  };
}
