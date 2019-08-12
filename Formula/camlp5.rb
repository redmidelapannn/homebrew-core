class Camlp5 < Formula
  desc "Preprocessor and pretty-printer for OCaml"
  homepage "https://camlp5.github.io/"
  url "https://github.com/camlp5/camlp5/archive/rel708.tar.gz"
  version "7.08"
  sha256 "46e67d8e36e5e4558c414f0b569532a33d3a12d7120ffdc474a6b3da1bfff163"
  revision 1
  head "https://gforge.inria.fr/anonscm/git/camlp5/camlp5.git"

  bottle do
    sha256 "a9cde2c7fbfab8f452007809e414f83ae0cddab90f640c56509bbd0aa3f90006" => :mojave
    sha256 "ad6ea50a63f7a3059ad1e03ced3840dcb277c8439ce93f5d8801d34bc6c5f4b0" => :high_sierra
    sha256 "5290d1ed6397492d6930d520e7ba89199169aab8ac506f27514a2f879cd3b915" => :sierra
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
