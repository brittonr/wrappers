{
  config,
  lib,
  ...
}:
let
  managingExtensions = config.extensions != null;

  # Convert settings attrset to policies.json Preferences format
  # Each pref gets Status = "default" so users can still override in about:config
  settingsToPreferences = lib.mapAttrs (_: value: {
    Value = value;
    Status = "default";
  }) config.settings;

  # Build extension policies matching the nixExtensions pattern from wrapFirefox:
  # - ExtensionSettings blocks manual installs, whitelists managed ones
  # - Extensions.Install provides file paths to XPIs
  extensionPolicies = lib.optionalAttrs managingExtensions {
    ExtensionSettings = {
      "*" = {
        blocked_install_message = "Extensions are managed by the wrapper module";
        installation_mode = "blocked";
      };
    } // lib.foldr (
      ext: acc:
      acc // {
        "${ext.extid}" = {
          installation_mode = "allowed";
        };
      }
    ) { } config.extensions;

    Extensions = {
      Install = map (ext: "${ext}/${ext.extid}.xpi") config.extensions;
    };
  };

  # fetchFirefoxAddon repacks XPIs to inject extid, which invalidates
  # Mozilla's signature. Disable signature enforcement when managing extensions.
  # NOTE: only works with browsers that allow it (ESR, LibreWolf) — Firefox
  # Release has MOZ_REQUIRE_SIGNING compiled in and ignores this pref.
  extensionPrefs = lib.optionalString (managingExtensions && config.extensions != [ ]) ''
    lockPref("xpinstall.signatures.required", false);
  '';

  # Merge all policy sources: extensions, then extraPolicies, then settings on top
  policies = lib.recursiveUpdate
    (lib.recursiveUpdate extensionPolicies config.extraPolicies)
    (lib.optionalAttrs (config.settings != { }) {
      Preferences = settingsToPreferences;
    });
in
{
  _class = "wrapper";

  options = {
    browser = lib.mkOption {
      type = lib.types.package;
      default = config.pkgs.librewolf-unwrapped;
      description = ''
        The unwrapped Firefox browser package.
        Defaults to librewolf-unwrapped which supports managed extensions.
        Can be swapped to `firefox-esr-unwrapped`, `firefox-unwrapped`, etc.
        Note: extension management requires a browser that allows addon
        sideloading (LibreWolf, ESR). Firefox Release does not.
      '';
    };

    settings = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.oneOf [
          lib.types.str
          lib.types.int
          lib.types.float
          lib.types.bool
        ]
      );
      default = { };
      description = ''
        about:config preferences. Converted to policies.json Preferences
        with Status = "default" (user can override in about:config).
      '';
    };

    extensions = lib.mkOption {
      type = lib.types.nullOr (lib.types.listOf lib.types.package);
      default = null;
      description = ''
        List of Firefox addon packages (from `fetchFirefoxAddon`).
        `null` = don't manage extensions (manual installs allowed).
        `[]` = manage but install none (blocks manual installs).
        Requires a browser that supports addon sideloading (ESR, LibreWolf).
      '';
    };

    nativeMessagingHosts = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
      description = "Native messaging host packages (e.g. tridactyl-native).";
    };

    extraPolicies = lib.mkOption {
      type = lib.types.attrs;
      default = { };
      description = ''
        Raw policies.json attributes. Merged with settings-derived
        Preferences (settings take precedence).
      '';
    };

    extraPrefs = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = "Raw mozilla.cfg JavaScript preferences (escape hatch).";
    };
  };

  config.package = config.pkgs.wrapFirefox config.browser {
    nativeMessagingHosts = config.nativeMessagingHosts;
    extraPolicies = policies;
    extraPrefs = extensionPrefs + config.extraPrefs;
  };

  config.meta.platforms = lib.platforms.linux;
}
