{
  inputs = {
    nixlib.url = "github:nix-community/nixpkgs.lib";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixlib, utils, ... }: {
    lib.mkFlake = (autoImports: configuration:
      with nixlib.lib;
      with utils.lib;
      let
        filterCrystals = path: builtins.path {
          name = "source";
          inherit path;
          filter = path: type: type != "regular" || baseNameOf path == "crystal.nix";
        };

        reduceCrystals = prefix: path: mapAttrsToList (name: type:
          if type == "regular"
          then [ "${prefix}${name}" ]
          else if type != "unknown"
          then reduceCrystals "${prefix}${name}/" "${path}/${name}"
          else []
        ) (builtins.readDir path);

        imports = flatten (map (root:
          reduceCrystals "${root}/" (filterCrystals root)
        ) (toList autoImports));

        eval = evalModules {
          specialArgs = {
            lib = nixlib.lib // utils.lib;
          };
          modules = [
            {
              inherit imports;
              _module.args.lib = nixlib.lib // utils.lib;
            }
            ./modules
            configuration
          ];
        };
      in eval.config.outputs);
  };
}
