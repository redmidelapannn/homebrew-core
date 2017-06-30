class Camlp4 < Formula
  desc "Tool to write extensible parsers in OCaml"
  homepage "https://github.com/ocaml/camlp4"
  url "https://github.com/ocaml/camlp4/archive/4.04+1.tar.gz"
  version "4.04+1"
  sha256 "6044f24a44053684d1260f19387e59359f59b0605cdbf7295e1de42783e48ff1"
  revision 1
  head "https://github.com/ocaml/camlp4.git", :branch => "trunk"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "794fd3de608c9699fc58c686a693c8ecf83a91524fc5bd94c1bd3379a12d4b8b" => :sierra
    sha256 "acb15512cde45b4d50b4328f587c33c3c781f536121168e6a43c4fbcf6fc2354" => :el_capitan
    sha256 "afec5fca91ca68da33489159aebbbd1b846806d79a2e0e4e78c5f455beeb7dda" => :yosemite
  end

  depends_on "ocaml"
  # since OCaml 4.03.0, ocamlbuild is no longer part of ocaml
  depends_on "ocamlbuild"

  def install
    # this build fails if jobs are parallelized
    ENV.deparallelize
    system "./configure", "--bindir=#{bin}",
                          "--libdir=#{HOMEBREW_PREFIX}/lib/ocaml",
                          "--pkgdir=#{HOMEBREW_PREFIX}/lib/ocaml/camlp4"
    system "make", "all"
    system "make", "install", "LIBDIR=#{lib}/ocaml",
                              "PKGDIR=#{lib}/lib/ocaml/camlp4"
  end

  test do
    (testpath/"foo.ml").write "type t = Homebrew | Rocks"
    system "#{bin}/camlp4", "-parser", "OCaml", "-printer", "OCamlr",
                            "foo.ml", "-o", testpath/"foo.ml.out"
    assert_equal "type t = [ Homebrew | Rocks ];",
                 (testpath/"foo.ml.out").read.strip
  end
end
