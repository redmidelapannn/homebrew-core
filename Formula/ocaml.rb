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
  url "https://caml.inria.fr/pub/distrib/ocaml-4.09/ocaml-4.09.0.tar.xz"
  sha256 "f2fb91dfe86bae00a33fc5ba51685e95a68564274f5277f787c31931b22a7fec"
  head "https://github.com/ocaml/ocaml.git", :branch => "trunk"

  bottle do
    cellar :any
    sha256 "533b6acbbe935c98d6013f284920ec7a6450039e1f1a0e3199e069bd9309d504" => :catalina
    sha256 "5ea7bbe76f2560f1708e0fe1d7eac750b7b63464b9649e9deff21389031187fe" => :mojave
    sha256 "204c83eee8730e3e5e61a6e82d210893d31746fcc3cdae0bef48e81fe7bacdfa" => :high_sierra
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
