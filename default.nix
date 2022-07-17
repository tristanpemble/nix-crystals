{ lib, ... }:

let
  filterCrystals = path: builtins.path {
    name = "source";
    inherit path;
    filter = path: type: type != "regular" || baseNameOf path == "crystal.nix";
  };

  reduceCrystals = prefix: path: lib.mapAttrsToList (name: type:
    if type == "regular"
    then [ "${prefix}/${name}" ]
    else if type != "unknown"
    then reduceCrystals "${prefix}/${name}" "${path}/${name}"
    else []
  ) (builtins.readDir path);

  discoverCrystals = paths:
    lib.flatten (map (root:
      reduceCrystals "${root}" (filterCrystals root)
    ) (lib.toList paths));

  evalCrystals = crystals:
    lib.evalModules {
      specialArgs = {
        inherit lib;
      };
      modules = [
        ./modules
      ] ++ (lib.toList crystals);
    };

  mkFlake = crystals:
    let eval = evalCrystals crystals;
    in eval.config.outputs;
in {
  lib = {
    inherit discoverCrystals evalCrystals mkFlake;
  };
}
