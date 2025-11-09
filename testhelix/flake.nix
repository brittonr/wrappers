{
  inputs.wrappers.url = "path:..";
  inputs.nixpkgs.follows = "wrappers/nixpkgs";

  outputs =
    {
      self,
      wrappers,
      nixpkgs,
    }:
    {
      packages.x86_64-linux.my-helix =
        (wrappers.wrapperModules.helix.apply {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          settings.theme = "portal-dark";
          themes.portal-dark = {
            # Interface - Aperture Labs dark theme
            "ui.background" = {
              bg = "#1a1a1a";
            };
            "ui.text" = {
              fg = "#ffffff";
            };
            "ui.statusline" = {
              bg = "#ff6600";
              fg = "#000000";
              modifiers = [ "bold" ];
            };
            "ui.statusline.insert" = {
              bg = "#0099ff";
              fg = "#ffffff";
              modifiers = [ "bold" ];
            };
            "ui.statusline.select" = {
              bg = "#888888";
              fg = "#ffffff";
              modifiers = [ "bold" ];
            };
            "ui.cursor" = {
              bg = "#ff6600";
            };
            "ui.cursor.primary" = {
              bg = "#0099ff";
            };
            "ui.selection" = {
              bg = "#333333";
            };
            "ui.menu" = {
              bg = "#2a2a2a";
              fg = "#ffffff";
            };
            "ui.menu.selected" = {
              bg = "#ff6600";
              fg = "#000000";
            };
            "ui.popup" = {
              bg = "#2a2a2a";
              fg = "#ffffff";
            };
            "ui.linenr" = {
              fg = "#666666";
            };
            "ui.linenr.selected" = {
              fg = "#ff6600";
              modifiers = [ "bold" ];
            };

            # Syntax - Portal colors
            "keyword" = {
              fg = "#ff6600";
              modifiers = [ "bold" ];
            };
            "keyword.control" = {
              fg = "#ff3300";
              modifiers = [ "bold" ];
            };
            "function" = {
              fg = "#0099ff";
              modifiers = [ "italic" ];
            };
            "function.builtin" = {
              fg = "#0066cc";
              modifiers = [ "bold" ];
            };
            "type" = {
              fg = "#cccccc";
            };
            "type.builtin" = {
              fg = "#aaaaaa";
              modifiers = [ "bold" ];
            };
            "string" = {
              fg = "#00cc66";
            };
            "string.regexp" = {
              fg = "#009944";
              modifiers = [ "italic" ];
            };
            "comment" = {
              fg = "#777777";
              modifiers = [ "italic" ];
            };
            "variable" = {
              fg = "#ffffff";
            };
            "variable.parameter" = {
              fg = "#ccccff";
            };
            "constant" = {
              fg = "#ffcc00";
              modifiers = [ "bold" ];
            };
            "constant.numeric" = {
              fg = "#ff9900";
            };
            "operator" = {
              fg = "#ff6600";
              modifiers = [ "bold" ];
            };
            "punctuation.bracket" = {
              fg = "#cccccc";
            };
            "tag" = {
              fg = "#0099ff";
              modifiers = [ "bold" ];
            };
            "attribute" = {
              fg = "#ff6600";
            };

            # Diagnostics
            "error" = {
              fg = "#ff3300";
              modifiers = [ "bold" ];
            };
            "warning" = {
              fg = "#ff6600";
              modifiers = [ "bold" ];
            };
            "info" = {
              fg = "#0099ff";
            };
            "hint" = {
              fg = "#888888";
            };

            # Portal gun colors for rainbow brackets
            rainbow = [
              "#ff6600"
              "#0099ff"
              "#888888"
              "#ffffff"
              "#00cc66"
              "#ffcc00"
            ];
          };
          themes.portal-light = {
            # Interface - Aperture Labs clean white theme
            "ui.background" = {
              bg = "#ffffff";
            };
            "ui.text" = {
              fg = "#333333";
            };
            "ui.statusline" = {
              bg = "#ff6600";
              fg = "#ffffff";
              modifiers = [ "bold" ];
            };
            "ui.statusline.insert" = {
              bg = "#0099ff";
              fg = "#ffffff";
              modifiers = [ "bold" ];
            };
            "ui.statusline.select" = {
              bg = "#666666";
              fg = "#ffffff";
              modifiers = [ "bold" ];
            };
            "ui.cursor" = {
              bg = "#ff6600";
            };
            "ui.cursor.primary" = {
              bg = "#0099ff";
            };
            "ui.selection" = {
              bg = "#e6f3ff";
            };
            "ui.menu" = {
              bg = "#f5f5f5";
              fg = "#333333";
            };
            "ui.menu.selected" = {
              bg = "#ff6600";
              fg = "#ffffff";
            };
            "ui.popup" = {
              bg = "#f0f0f0";
              fg = "#333333";
            };
            "ui.linenr" = {
              fg = "#aaaaaa";
            };
            "ui.linenr.selected" = {
              fg = "#ff6600";
              modifiers = [ "bold" ];
            };

            # Syntax - Clean lab aesthetic
            "keyword" = {
              fg = "#ff6600";
              modifiers = [ "bold" ];
            };
            "keyword.control" = {
              fg = "#cc3300";
              modifiers = [ "bold" ];
            };
            "function" = {
              fg = "#0066cc";
              modifiers = [ "italic" ];
            };
            "function.builtin" = {
              fg = "#004499";
              modifiers = [ "bold" ];
            };
            "type" = {
              fg = "#555555";
            };
            "type.builtin" = {
              fg = "#333333";
              modifiers = [ "bold" ];
            };
            "string" = {
              fg = "#008844";
            };
            "string.regexp" = {
              fg = "#006633";
              modifiers = [ "italic" ];
            };
            "comment" = {
              fg = "#999999";
              modifiers = [ "italic" ];
            };
            "variable" = {
              fg = "#333333";
            };
            "variable.parameter" = {
              fg = "#4455cc";
            };
            "constant" = {
              fg = "#cc8800";
              modifiers = [ "bold" ];
            };
            "constant.numeric" = {
              fg = "#ff6600";
            };
            "operator" = {
              fg = "#ff3300";
              modifiers = [ "bold" ];
            };
            "punctuation.bracket" = {
              fg = "#666666";
            };
            "tag" = {
              fg = "#0099ff";
              modifiers = [ "bold" ];
            };
            "attribute" = {
              fg = "#ff6600";
            };

            # Diagnostics
            "error" = {
              fg = "#cc0000";
              modifiers = [ "bold" ];
            };
            "warning" = {
              fg = "#ff6600";
              modifiers = [ "bold" ];
            };
            "info" = {
              fg = "#0066cc";
            };
            "hint" = {
              fg = "#999999";
            };

            # Portal gun colors for rainbow brackets
            rainbow = [
              "#ff6600"
              "#0099ff"
              "#666666"
              "#333333"
              "#008844"
              "#cc8800"
            ];
          };
        }).wrapper;
    };
}
