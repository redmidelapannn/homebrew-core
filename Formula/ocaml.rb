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
  url "https://caml.inria.fr/pub/distrib/ocaml-4.07/ocaml-4.07.1.tar.xz"
  sha256 "dfe48b1da31da9c82d77612582fae74c80e8d1ac650e1c24f5ac9059e48307b8"
  head "https://github.com/ocaml/ocaml.git", :branch => "trunk"

  bottle do
    cellar :any
    rebuild 1
    sha256 "b6dd5a8f817717f1836326c47610d3525baf9b16204a76a311563a25528b983e" => :mojave
    sha256 "b165b6cc6c86fa04dcd92740ad1b042f5dc44e1344d5d0ecff8bd6c9b08b1dee" => :high_sierra
    sha256 "63221325851938d242bacfb1e3b60dd084547f7b2a81a20ad2c819829a89762b" => :sierra
  end

  pour_bottle? do
    # The ocaml compilers embed prefix information in weird ways that the default
    # brew detection doesn't find, and so needs to be explicitly blacklisted.
    reason "The bottle needs to be installed into /usr/local."
    satisfy { HOMEBREW_PREFIX.to_s == "/usr/local" }
  end

  def install
    ENV.deparallelize # Builds are not parallel-safe, esp. with many cores

    # the ./configure in this package is NOT a GNU autoconf script!
    args = [
      "-prefix",
      HOMEBREW_PREFIX.to_s,
      "-with-debug-runtime",
      "-mandir",
      man.to_s,
      "-no-graph",
    ]
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
