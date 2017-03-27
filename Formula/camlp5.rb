class Camlp5 < Formula
  desc "Preprocessor and pretty-printer for OCaml"
  homepage "http://camlp5.gforge.inria.fr/"
  url "https://github.com/camlp5/camlp5/archive/rel617.tar.gz"
  version "6.17"
  sha256 "8fa2a46a7030b1194862650cbb71ab52a10a0174890560a8b6edf236f8937414"
  head "https://gforge.inria.fr/anonscm/git/camlp5/camlp5.git"

  bottle do
    rebuild 1
    sha256 "7c8955df89320c0e0e658e772c90c95e67b58a026378db05818f1bf0b3568d03" => :sierra
    sha256 "5465592076b2628aeef150912a5120a857ac7a5b7c85e886bd40ffb01b15667c" => :el_capitan
    sha256 "3d0527d39171862651168f8210a705538267f1599bef7b5fdd5d0357b1790a72" => :yosemite
  end

  deprecated_option "strict" => "with-strict"
  option "with-strict", "Compile in strict mode (not recommended)"

  depends_on "ocaml"

  def install
    args = ["--prefix", prefix, "--mandir", man]
    args << "--transitional" if build.without? "strict"

    system "./configure", *args
    system "make", "world.opt"
    system "make", "install"
  end

  test do
    (testpath/"hi.ml").write "print_endline \"Hi!\";;"
    assert_equal "let _ = print_endline \"Hi!\"", shell_output("#{bin}/camlp5 #{lib}/ocaml/camlp5/pa_o.cmo #{lib}/ocaml/camlp5/pr_o.cmo hi.ml")
  end
end
