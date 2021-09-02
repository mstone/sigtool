{
  description = "A minimal multicall binary providing helpers for working with embedded signatures in Mach-O files.";

  inputs.utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, utils }: let
    name = "sigtool";
  in utils.lib.simpleFlake {
    inherit self nixpkgs name;
    systems = utils.lib.defaultSystems;
    overlay = (final: prev: {
      sigtool = with final; rec {
        sigtool = stdenv.mkDerivation {
          inherit name;
          src = self;
          nativeBuildInputs = [ pkg-config makeWrapper ];
	  buildInputs = [ openssl ];
          installFlags = [ "PREFIX=$(out)" ];
        };
        defaultPackage = sigtool;
      };
    });
  };
}
