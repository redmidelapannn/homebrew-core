class Camlp5 < Formula
  desc "Preprocessor and pretty-printer for OCaml"
  homepage "https://camlp5.github.io/"
  url "https://github.com/camlp5/camlp5/archive/rel710.tar.gz"
  version "7.10"
  sha256 "83dff83d33ee9b70cd1b9d8d365db63a118201e5feb6aab49d9d3b1d62621784"
  revision 1
  head "https://gforge.inria.fr/anonscm/git/camlp5/camlp5.git"

  bottle do
    sha256 "079267e40ac6a5367dd553259565fe062b2ffe112b28346cefb981a24d67d95e" => :catalina
    sha256 "da237a2b651cf7341913a1650ba82ca95f00a46965131547b1b1452b9a503b99" => :mojave
    sha256 "123787c50ff062140770c6acff760b3080d063c38812f1defa28f51ae4b375f1" => :high_sierra
  end

  depends_on "ocaml"

  def install
    system "./configure", "--prefix", prefix, "--mandir", man
    system "make", "world.opt"
    system "make", "install"
    (lib/"ocaml/camlp5").install "etc/META"
  end

  test do
    ocaml = Formula["ocaml"]
    (testpath/"hi.ml").write "print_endline \"Hi!\";;"
    assert_equal "let _ = print_endline \"Hi!\"",
      # The purpose of linking with the file "bigarray.cma" is to ensure that the
      # ocaml files are in sync with the camlp5 files.  If camlp5 has been
      # compiled with an older version of the ocaml compiler, then an error
      # "interface mismatch" will occur.
      shell_output("#{bin}/camlp5 #{lib}/ocaml/camlp5/pa_o.cmo #{lib}/ocaml/camlp5/pr_o.cmo #{ocaml.opt_lib}/ocaml/bigarray.cma hi.ml")
  end
end
