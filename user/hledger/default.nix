{ pkgs, config, ... }:
{
  home.packages = [ pkgs.hledger ];
  home.sessionVariables.LEDGER_FILE = "${config.home.homeDirectory}/sync/ledger/2023.journal";
}
