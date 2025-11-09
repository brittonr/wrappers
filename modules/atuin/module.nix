{
  wlib,
  lib,
  ...
}:
wlib.wrapModule (
  { config, wlib, ... }:
  let
    tomlFmt = config.pkgs.formats.toml { };
    configFile = tomlFmt.generate "atuin-config.toml" config.settings;
  in
  {
    options = {
      settings = lib.mkOption {
        type = tomlFmt.type;
        default = { };
        description = ''
          Atuin configuration settings.
          See <https://docs.atuin.sh/configuration/config/>
        '';
      };
    };

    config.package = lib.mkDefault config.pkgs.atuin;

    # Atuin reads config from XDG_CONFIG_HOME/atuin/config.toml
    config.env = {
      XDG_CONFIG_HOME = builtins.toString (
        config.pkgs.linkFarm "atuin-config" [
          {
            name = "atuin/config.toml";
            path = configFile;
          }
        ]
      );
    };

    config.meta.maintainers = [
      {
        name = "brittonr";
        github = "brittonr";
      }
    ];
    config.meta.platforms = lib.platforms.all;
  }
)
