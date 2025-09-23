{
  description = "APA-I course – VS Code + selected extensions";

  inputs = {
    nixpkgs.url      = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url  = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;      # allow VS Code
        };

        vscode-with-extensions = pkgs.vscode-with-extensions.override {
          vscodeExtensions = with pkgs.vscode-extensions; [
            ms-vscode-remote.remote-containers
            jnoortheen.nix-ide
            usernamehw.errorlens
            ms-vsliveshare.vsliveshare
            eamodio.gitlens
          ];
        };

        # absolute path to the real binary
        codeBin = "${vscode-with-extensions}/bin/code";
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = [ vscode-with-extensions ];

          shellHook = ''
            echo
            echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
            echo "  APA-I course shell – VS Code ready"
            echo
            echo "  Launch the Nix-provided VS Code with:"
            echo
            echo "     ${codeBin} ."
            echo
            echo "  Then click 'Reopen in Container' when prompted."
            echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
            echo
          '';
        };
      });
}