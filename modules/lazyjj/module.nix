{
  wlib,
  lib,
  ...
}:
wlib.wrapModule (
  { config, wlib, ... }:
  let
    tomlFmt = config.pkgs.formats.toml { };
    configFile = tomlFmt.generate "lazyjj-config.toml" config.settings;
  in
  {
    options = {
      settings = lib.mkOption {
        type = tomlFmt.type;
        default = { };
        description = ''
          LazyJJ configuration settings.
          See <https://github.com/Cretezy/lazyjj>
        '';
      };
    };

    config.package = lib.mkDefault config.pkgs.lazyjj;

    # LazyJJ reads config from XDG_CONFIG_HOME/lazyjj/config.toml
    config.env = {
      XDG_CONFIG_HOME = builtins.toString (
        config.pkgs.linkFarm "lazyjj-config" [
          {
            name = "lazyjj/config.toml";
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
