{ lib, ... }:

with lib;

{
  options.machines = mkOption {
    type = with types; attrsOf raw;
    default = {};
  };
}