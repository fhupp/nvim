{ nvim }:
{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.neo-visual-ex-improved;
in
{
  _class = "nixos";

  options.neo-visual-ex-improved = {
    enable = lib.mkEnableOption "neo-visual-ex-improved";
  };

  config.environment.systemPackages = lib.mkIf cfg.enable [ nvim ];
}
