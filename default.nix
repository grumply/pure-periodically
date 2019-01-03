{ mkDerivation, base, pure-core, pure-default, stdenv }:
mkDerivation {
  pname = "pure-periodically";
  version = "0.7.0.0";
  src = ./.;
  libraryHaskellDepends = [ base pure-core pure-default ];
  homepage = "github.com/grumply/pure-periodically";
  description = "Periodically decorator";
  license = stdenv.lib.licenses.bsd3;
}
