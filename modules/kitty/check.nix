{
  pkgs,
  self,
}:

let
  kittyWrapped =
    (self.wrapperModules.kitty.apply {
      inherit pkgs;
      settings = {
        # Test with some basic settings
        font_size = 12;
        background_opacity = "0.95";
        cursor_shape = "block";
        enable_audio_bell = false;
      };
      keybindings = {
        "ctrl+shift+c" = "copy_to_clipboard";
        "ctrl+shift+v" = "paste_from_clipboard";
      };
    }).wrapper;

in
pkgs.runCommand "kitty-test" { } ''
  # Test that the wrapped binary exists and runs
  "${kittyWrapped}/bin/kitty" --version | grep -q "kitty"
  touch $out
''
