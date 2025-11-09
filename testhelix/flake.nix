  {
    inputs.wrappers.url = "path:.";
    inputs.nixpkgs.url = "github:NixOS/nixpkgs";

    outputs = { self, wrappers, nixpkgs }: {
      packages.x86_64-linux.my-helix =
        (wrappers.wrapperModules.helix.apply {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          settings.editor.line-number = "relative";
        }).wrapper;
    };
  }
