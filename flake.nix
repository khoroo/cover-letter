{
  description = "A flake for generating cover letters";

  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
        mytex = pkgs.texlive.combine {
          inherit (pkgs.texlive)
            scheme-minimal
            koma-script
            latex-bin
            latexmk
            amsfonts
            amsmath
            lm
            fontspec
            unicode-math
            hyperref
            xcolor
            geometry
            microtype
            babel
            etoolbox
            csquotes
            bookmark
            xurl
            ;
        };
        # Create a custom vimrc
        vimConfig = pkgs.writeText "letter-vimrc" ''
          	autocmd BufWritePost *.md !pandoc %:t -o %:t:r.pdf --template="pandoc-letter-din5008/letter"
        '';
      in
      {
        devShell = pkgs.mkShell {
          buildInputs = [
            pkgs.pandoc
            mytex
          ];
          shellHook = ''
            export VIMINIT="source ${vimConfig}"
            echo "Vim configured: will auto-convert letter.md on save"
          '';
        };

      }
    );
}
