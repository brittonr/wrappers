{
  pkgs,
  self,
}:

let
  firefoxWrapped =
    (self.wrapperModules.firefox.apply {
      inherit pkgs;
      settings = {
        "browser.startup.homepage" = "about:blank";
      };
    }).wrapper;

in
pkgs.runCommand "firefox-test" { } ''
  "${firefoxWrapped}/bin/librewolf" --version | grep -qi "mozilla\|firefox\|librewolf"
  touch $out
''
