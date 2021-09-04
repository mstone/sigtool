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
        bintools = prev.bintools.overrideAttrs (old: {
          postFixup = builtins.replaceStrings ["-no_uuid"] [""] old.postFixup;
        });
        cc = prev.stdenv.cc.overrideAttrs (old: {
          bintools = bintools;
        });
        stdenv = prev.overrideCC prev.stdenv cc;
        sigtool = stdenv.mkDerivation {
          inherit name;
          src = self;
          nativeBuildInputs = [ pkg-config meson ninja ];
          buildInputs = [ openssl ];
          dontStrip = true;
          separateDebugInfo = true;
          mesonBuildType = "debug";
          ninjaFlags = "-v";
        };
        defaultPackage = sigtool;
      };
    });
  };
}
