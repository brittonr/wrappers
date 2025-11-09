{
  wlib,
  lib,
  ...
}:
wlib.wrapModule (
  { config, wlib, ... }:
  let
    # Generate kitty.conf format (simple key value pairs)
    generateKittyConf =
      settings:
      lib.concatStringsSep "\n" (
        lib.mapAttrsToList (
          key: value:
          let
            valueStr =
              if builtins.isBool value then
                (if value then "yes" else "no")
              else if builtins.isInt value || builtins.isFloat value then
                toString value
              else
                value;
          in
          "${key} ${valueStr}"
        ) settings
      );

    configFile = config.pkgs.writeText "kitty.conf" (
      generateKittyConf config.settings
      + (if config.extraConfig != "" then "\n\n${config.extraConfig}" else "")
    );

    # Generate keybindings section
    keybindingsConf =
      if config.keybindings != { } then
        lib.concatStringsSep "\n" (
          lib.mapAttrsToList (key: action: "map ${key} ${action}") config.keybindings
        )
      else
        "";

    fullConfigFile = config.pkgs.writeText "kitty.conf" ''
      ${generateKittyConf config.settings}

      ${keybindingsConf}

      ${config.extraConfig}
    '';
  in
  {
    options = {
      settings = lib.mkOption {
        type = lib.types.attrsOf lib.types.anything;
        default = { };
        description = ''
          Kitty configuration settings.
          See <https://sw.kovidgoyal.net/kitty/conf/>
        '';
      };

      keybindings = lib.mkOption {
        type = lib.types.attrsOf lib.types.str;
        default = { };
        description = ''
          Kitty keyboard shortcuts.
          Key-value pairs where key is the key combination and value is the action.
        '';
      };

      extraConfig = lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = ''
          Extra lines to append to kitty.conf.
          Useful for advanced configuration or comments.
        '';
      };
    };

    config.package = lib.mkDefault config.pkgs.kitty;

    # Kitty reads config from KITTY_CONFIG_DIRECTORY/kitty.conf
    config.env = {
      KITTY_CONFIG_DIRECTORY = builtins.toString (
        config.pkgs.linkFarm "kitty-config" [
          {
            name = "kitty.conf";
            path = fullConfigFile;
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
