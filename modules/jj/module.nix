{
  wlib,
  lib,
  ...
}:
wlib.wrapModule (
  { config, wlib, ... }:
  let
    tomlFmt = config.pkgs.formats.toml { };
    configFile = tomlFmt.generate "jj-config.toml" config.settings;
  in
  {
    options = {
      settings = lib.mkOption {
        type = tomlFmt.type;
        default = { };
        description = ''
          Jujutsu configuration settings.
          See <https://martinvonz.github.io/jj/latest/config/>
        '';
      };
    };

    config.package = lib.mkDefault config.pkgs.jujutsu;

    # Jujutsu reads config from XDG_CONFIG_HOME/jj/config.toml
    config.env = {
      XDG_CONFIG_HOME = builtins.toString (
        config.pkgs.linkFarm "jj-config" [
          {
            name = "jj/config.toml";
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
