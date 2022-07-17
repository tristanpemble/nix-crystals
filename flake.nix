{
  inputs = {
    nixlib.url = "github:nix-community/nixpkgs.lib";
  };

  outputs = { nixlib, ... }@inputs:
    let crystals = import ./. { inherit (nixlib) lib; }; in
    crystals.lib.mkFlake {
      inherit inputs;
      imports = [
        ./default.nix
      ];
    };
}
