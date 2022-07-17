{ lib, ... }:

with lib;

{
  options.modules = mkOption {
    type = with types; attrsOf raw;
    default = {};
  };
}