class Camlp5 < Formula
  desc "Preprocessor and pretty-printer for OCaml"
  homepage "https://camlp5.github.io/"
  url "https://github.com/camlp5/camlp5/archive/rel706.tar.gz"
  version "7.06"
  sha256 "bea3fba40305b6299a4a65a26f8e1f1caf844abec61588ff1c500e9c05047922"
  revision 1
  head "https://gforge.inria.fr/anonscm/git/camlp5/camlp5.git"

  bottle do
    rebuild 1
    sha256 "9da6145f9a4e90660ff15c481c159b79b81a81d2a6a264ba61dae0553eafb559" => :mojave
    sha256 "d2cb3658ff843ebb7ccdfc8a4d917ef001f3ff0cca4ec6ef5ccf88198d9fbe3f" => :high_sierra
    sha256 "2d53eab2111d215587032c315641e1b653c32529990869f7386bef17578d608a" => :sierra
  end

  depends_on "ocaml"

  def install
    system "./configure", "--prefix", prefix, "--mandir", man
    system "make", "world.opt"
    system "make", "install"
    (lib/"ocaml/camlp5").install "etc/META"
  end

  test do
    (testpath/"hi.ml").write "print_endline \"Hi!\";;"
    assert_equal "let _ = print_endline \"Hi!\"",
      shell_output("#{bin}/camlp5 #{lib}/ocaml/camlp5/pa_o.cmo #{lib}/ocaml/camlp5/pr_o.cmo hi.ml")
  end
end
