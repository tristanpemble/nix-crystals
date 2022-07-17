{ lib, ... }:

with lib;

{
  options.apps = mkOption {
    type = with types; attrsOf raw;
    default = {};
  };
}