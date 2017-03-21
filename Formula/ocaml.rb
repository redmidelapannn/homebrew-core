# OCaml does not preserve binary compatibility across compiler releases,
# so when updating it you should ensure that all dependent packages are
# also updated by incrementing their revisions.
#
# Specific packages to pay attention to include:
# - camlp4
# - opam
#
# Applications that really shouldn't break on a compiler update are:
# - mldonkey
# - coq
# - coccinelle
# - unison
class Ocaml < Formula
  desc "General purpose programming language in the ML family"
  homepage "https://ocaml.org/"
  url "https://caml.inria.fr/pub/distrib/ocaml-4.04/ocaml-4.04.0.tar.xz"
  sha256 "64ed6dad2316d5dff7440cea89f0f0abe07ce508b9104d1bfadf3782e79856b4"
  head "https://caml.inria.fr/svn/ocaml/trunk", :using => :svn

  pour_bottle? do
    # The ocaml compilers embed prefix information in weird ways that the default
    # brew detection doesn't find, and so needs to be explicitly blacklisted.
    reason "The bottle needs to be installed into /usr/local."
    satisfy { HOMEBREW_PREFIX.to_s == "/usr/local" }
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "77d04be20a1ac8b5007518de219c9ef589e6c51dbc03dffc7920ceb9674c26b0" => :sierra
    sha256 "69fa9a86b39274ed93be2a24af29d8e29204b78b6b131c83ee16908bab9b8a71" => :el_capitan
  end

  devel do
    url "https://github.com/ocaml/ocaml/archive/4.05.0+beta3.tar.gz"
    version "4.05.0+beta3"
    sha256 "3d82d5b32310d1c010981c12508e0ff63fb71b0c89457bcac813b7c291d4b61c"
  end

  option "with-x11", "Install with the Graphics module"
  option "with-flambda", "Install with flambda support"

  depends_on :x11 => :optional

  def install
    ENV.deparallelize # Builds are not parallel-safe, esp. with many cores

    # the ./configure in this package is NOT a GNU autoconf script!
    args = ["-prefix", HOMEBREW_PREFIX.to_s, "-with-debug-runtime", "-mandir", man]
    args << "-no-graph" if build.without? "x11"
    args << "-flambda" if build.with? "flambda"
    system "./configure", *args

    system "make", "world.opt"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    output = shell_output("echo 'let x = 1 ;;' | #{bin}/ocaml 2>&1")
    assert_match "val x : int = 1", output
    assert_match HOMEBREW_PREFIX.to_s, shell_output("#{bin}/ocamlc -where")
  end
end
