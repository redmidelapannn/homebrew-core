class Camlp5 < Formula
  desc "Preprocessor and pretty-printer for OCaml"
  homepage "https://camlp5.github.io/"
  url "https://github.com/camlp5/camlp5/archive/rel711.tar.gz"
  version "7.11"
  sha256 "a048b8e0feb2a1058187824fc9cb6b55f2c5b788c43c15d6db090d789c7121ba"
  revision 2
  head "https://gforge.inria.fr/anonscm/git/camlp5/camlp5.git"

  bottle do
    sha256 "5f4c65ef2e2a4f973a4113d575d0e8cde2a6134a68b955223a7f436b4892d972" => :catalina
    sha256 "6e69199abd0206a75cf936841a1dd12bc73a84802613f3b7894acf8f070c2272" => :mojave
    sha256 "17b8a7fd279ec44df89e00b5e36c18d8e155c19d94dc28d9b55fcc80bdc582e8" => :high_sierra
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
      shell_output("#{bin}/camlp5 #{lib}/ocaml/camlp5/pa_o.cmo #{lib}/ocaml/camlp5/pr_o.cmo " \
                   "#{ocaml.opt_lib}/ocaml/bigarray.cma hi.ml")
  end
end
