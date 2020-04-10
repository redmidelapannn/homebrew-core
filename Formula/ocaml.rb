# OCaml does not preserve binary compatibility across compiler releases,
# so when updating it you should ensure that all dependent packages are
# also updated by incrementing their revisions.
#
# Specific packages to pay attention to include:
# - camlp5
# - lablgtk
#
# Applications that really shouldn't break on a compiler update are:
# - coq
# - coccinelle
# - unison
class Ocaml < Formula
  desc "General purpose programming language in the ML family"
  homepage "https://ocaml.org/"
  url "https://caml.inria.fr/pub/distrib/ocaml-4.10/ocaml-4.10.0.tar.xz"
  sha256 "30734db17b609fdd1609c39a05912325c299023968a2c783e5955dd5163dfeb7"
  head "https://github.com/ocaml/ocaml.git", :branch => "trunk"

  bottle do
    cellar :any
    sha256 "3f992a364124336b4ba360153347caa87bc924f8f8848be398b27ea7a3c0afe9" => :catalina
    sha256 "7009052bd1cf0d668cdb1ba03a6089b569546a27b7ca1ef4078897da750e14b6" => :mojave
    sha256 "8950f31ba028d28cc780cec8c653d07a9d4207d36fd8235de986ee2ae7fa3a32" => :high_sierra
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
    args = %W[
      --prefix=#{HOMEBREW_PREFIX}
      --enable-debug-runtime
      --mandir=#{man}
    ]
    system "./configure", *args
    system "make", "world.opt"
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    output = shell_output("echo 'let x = 1 ;;' | #{bin}/ocaml 2>&1")
    assert_match "val x : int = 1", output
    assert_match HOMEBREW_PREFIX.to_s, shell_output("#{bin}/ocamlc -where")
  end
end
