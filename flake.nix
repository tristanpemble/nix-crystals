{
  inputs = {
    nixlib.url = "github:nix-community/nixpkgs.lib";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixlib, utils, ... }@inputs:
    let lib = nixlib.lib // utils.lib; in
    let crystals = import ./. { inherit lib; }; in
    crystals.lib.mkFlake {
      inputs = inputs;
      imports = [
        ./default.nix
      ];
    };
}
