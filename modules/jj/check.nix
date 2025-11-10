{ pkgs, self, ... }:
let
  jj = self.wrapperModules.jj.apply {
    inherit pkgs;
    settings = {
      user = {
        name = "Test User";
        email = "test@example.com";
      };
    };
  };
in
jj.wrapper
