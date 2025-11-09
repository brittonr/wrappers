{
  pkgs,
  self,
}:

let
  atuinWrapped =
    (self.wrapperModules.atuin.apply {
      inherit pkgs;
      settings = {
        # Test with some basic settings
        style = "compact";
        search_mode = "fuzzy";
      };
    }).wrapper;

in
pkgs.runCommand "atuin-test" { } ''
  # Test that the wrapped binary exists and runs
  "${atuinWrapped}/bin/atuin" --version | grep -q "atuin"
  touch $out
''
