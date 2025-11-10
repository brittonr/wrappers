{ pkgs, self, ... }:
let
  lazyjj = self.wrapperModules.lazyjj.apply {
    inherit pkgs;
    settings = { };
  };
in
lazyjj.wrapper
