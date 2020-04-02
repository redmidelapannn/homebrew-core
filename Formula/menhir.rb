class Menhir < Formula
  desc "LR(1) parser generator for the OCaml programming language"
  homepage "http://cristal.inria.fr/~fpottier/menhir"
  url "https://gitlab.inria.fr/fpottier/menhir/-/archive/20200211/menhir-20200211.tar.bz2"
  sha256 "003df5e553660a8bdeb9a9f45185f8c5dfa63f85f361ad494dbfa81eed34acbd"
  revision 1

  bottle do
    cellar :any
    sha256 "81e0b149f4d6e80a4a5daebb676e26cc79f62531f622760127161ca626998496" => :catalina
    sha256 "b7eb03b52e8bda61ae1ed0c94f4cce393559ca0aef406fafde8529849b9dd5f0" => :mojave
    sha256 "cf348262aa7d1c957a24d5602b5c660deeb82602dd8852523e7cd4ae1f3f9807" => :high_sierra
  end

  depends_on "dune" => :build
  depends_on "ocamlbuild" => :build
  depends_on "ocaml"

  def install
    system "dune", "build", "@install"
    system "dune", "install", "--prefix=#{prefix}", "--mandir=#{man}"
  end

  test do
    (testpath/"test.mly").write <<~EOS
      %token PLUS TIMES EOF
      %left PLUS
      %left TIMES
      %token<int> INT
      %start<int> prog
      %%

      prog: x=exp EOF { x }

      exp: x = INT { x }
      |    lhs = exp; op = op; rhs = exp  { op lhs rhs }

      %inline op: PLUS { fun x y -> x + y }
                | TIMES { fun x y -> x * y }
    EOS

    system "#{bin}/menhir", "--dump", "--explain", "--infer", "test.mly"
    assert_predicate testpath/"test.ml", :exist?
    assert_predicate testpath/"test.mli", :exist?
  end
end
