{ pkgs, self, ... }:
let
  jjui = self.wrapperModules.jjui.apply {
    inherit pkgs;
    settings = { };
  };
in
jjui.wrapper
