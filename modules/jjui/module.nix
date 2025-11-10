{
  wlib,
  lib,
  ...
}:
wlib.wrapModule (
  { config, wlib, ... }:
  let
    tomlFmt = config.pkgs.formats.toml { };
    configFile = tomlFmt.generate "jjui-config.toml" config.settings;
  in
  {
    options = {
      settings = lib.mkOption {
        type = tomlFmt.type;
        default = { };
        description = ''
          jjui configuration settings.
          See <https://github.com/idursun/jjui>
        '';
      };
    };

    config.package = lib.mkDefault config.pkgs.jjui;

    # jjui reads config from XDG_CONFIG_HOME/jjui/config.toml
    config.env = {
      XDG_CONFIG_HOME = builtins.toString (
        config.pkgs.linkFarm "jjui-config" [
          {
            name = "jjui/config.toml";
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
