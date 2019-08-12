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
  url "https://caml.inria.fr/pub/distrib/ocaml-4.08/ocaml-4.08.1.tar.xz"
  sha256 "cd4f180453ffd7cc6028bb18954b3d7c3f715af13157df2f7c68bdfa07655ea3"
  head "https://github.com/ocaml/ocaml.git", :branch => "trunk"

  bottle do
    sha256 "a85d1861023ec017819c5dc9427cdd0a38a8bd63004423fd9fcdbb54266f1bb3" => :mojave
    sha256 "d65314abbf12dc4c40048e4711d802a4132f2920a48bef83c21dffcd97e0d45c" => :high_sierra
    sha256 "f91830c4f2fb6c47cc701088283f3c0ec52f85deb05c87ac784594ac893d08d3" => :sierra
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
      "--prefix=#{prefix}",
      "--mandir=#{man}",
      "--disable-graph-lib",
    ]
    system "./configure", *args
    system "make", "world.opt"
    system "make", "install"
  end

  test do
    output = shell_output("echo 'let x = 1 ;;' | #{bin}/ocaml 2>&1")
    assert_match "val x : int = 1", output
    assert_match HOMEBREW_PREFIX.to_s, shell_output("#{bin}/ocamlc -where")
  end
end
