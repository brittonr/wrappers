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
    themes = lib.mapAttrsToList (
      name: value:
      let
        fname = "atuin-theme-${name}";
      in
      {
        name = "themes/${name}.toml";
        path =
          if lib.isString value then config.pkgs.writeText fname value else (tomlFmt.generate fname value);
      }
    ) config.themes;
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

      themes = lib.mkOption {
        type = lib.types.attrsOf (
          lib.types.oneOf [
            tomlFmt.type
            lib.types.lines
          ]
        );
        description = ''
          Themes to add to atuin.
          See <https://docs.atuin.sh/guide/theming/>
        '';
        default = { };
      };
    };

    config.package = lib.mkDefault config.pkgs.atuin;

    # Atuin reads config from XDG_CONFIG_HOME/atuin/config.toml
    # and themes from XDG_CONFIG_HOME/atuin/themes/*.toml
    config.env = {
      XDG_CONFIG_HOME = builtins.toString (
        config.pkgs.linkFarm "atuin-config" (
          map
            (a: {
              inherit (a) path;
              name = "atuin/" + a.name;
            })
            (
              [
                {
                  name = "config.toml";
                  path = configFile;
                }
              ]
              ++ themes
            )
        )
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
