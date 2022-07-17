{ config, ... }:

rec {
  packages.default = packages.hello-world;
  packages.hello-world = { name, self, lib, runCommand, stdenv, flake, inputs, outputs, system }:
    lib.mkIf stdenv.isDarwin (runCommand "hello-world" {
      FOO = "bar";
    } ''
      echo ${name} >> $out
      echo ${flake.sourceInfo} >> $out
      echo ${builtins.concatStringsSep " " (builtins.attrNames flake)} >> $out
      echo ${builtins.concatStringsSep " " (builtins.attrNames inputs)} >> $out
      echo ${builtins.concatStringsSep " " (builtins.attrNames outputs)} >> $out
      echo hello world! >> $out
    '');
}
