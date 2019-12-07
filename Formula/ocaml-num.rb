class OcamlNum < Formula
  desc "OCaml legacy Num library for arbitrary-precision arithmetic"
  homepage "https://github.com/ocaml/num"
  url "https://github.com/ocaml/num/archive/v1.2.tar.gz"
  sha256 "c5023104925ff4a79746509d4d85294d8aafa98da6733e768ae53da0355453de"
  revision 2

  bottle do
    cellar :any
    sha256 "0e2e89ce2d1dd6a84256c74f92e4e31cddad210d74952a32bc344c017cb903b7" => :catalina
    sha256 "f926912736dcd3eea4397ee77933db6a0ce84bf3cc462035ed0af4333f87173a" => :mojave
    sha256 "cfbbaeefe800c782f75e98199e7cad713aa1f3d26682abe0ee160ff74482bd0b" => :high_sierra
  end

  depends_on "ocaml-findlib" => :build
  depends_on "ocaml"

  def install
    ENV["OCAMLFIND_DESTDIR"] = lib/"ocaml"

    (lib/"ocaml").mkpath
    cp Formula["ocaml"].opt_lib/"ocaml/Makefile.config", lib/"ocaml"

    # install in #{lib}/ocaml not #{HOMEBREW_PREFIX}/lib/ocaml
    inreplace lib/"ocaml/Makefile.config", /^prefix=#{HOMEBREW_PREFIX}$/,
                                           "prefix=#{prefix}"

    system "make"
    (lib/"ocaml/stublibs").mkpath # `make install` assumes this directory exists
    system "make", "install", "STDLIBDIR=#{lib}/ocaml"

    pkgshare.install "test"

    rm lib/"ocaml/Makefile.config" # avoid conflict with ocaml
  end

  test do
    cp_r pkgshare/"test/.", "."
    system Formula["ocaml"].opt_bin/"ocamlopt", "-I", lib/"ocaml", "-I",
           Formula["ocaml"].opt_lib/"ocaml", "-o", "test", "nums.cmxa",
           "test.ml", "test_nats.ml", "test_big_ints.ml", "test_ratios.ml",
           "test_nums.ml", "test_io.ml", "end_test.ml"
    assert_match "1... 2... 3", shell_output("./test")
  end
end
