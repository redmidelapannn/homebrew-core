class Coccinelle < Formula
  desc "Program matching and transformation engine for C code"
  homepage "http://coccinelle.lip6.fr/"
  url "http://coccinelle.lip6.fr/distrib/coccinelle-1.0.6.tgz"
  sha256 "8452ed265c209dae99cbb33b67bc7912e72f8bca1e24f33f1a88ba3d7985e909"
  revision 1

  bottle do
    rebuild 1
    sha256 "3a3f758c31cb7cc9682e31652285685451ecb1d205f103535a69976167084563" => :high_sierra
    sha256 "aa4bdb4a76cdcb81ffc77a107647f3a5ac66dfb3ecccd745f3d3b100a3147a04" => :sierra
    sha256 "05b988016c6ed1f6b7ac224c8302e5624cd1960c48e3c28335771542c3ac95ef" => :el_capitan
  end

  depends_on "ocaml"
  depends_on "camlp4"
  depends_on "opam" => :build
  depends_on "hevea" => :build

  def install
    opamroot = buildpath/"opamroot"
    ENV["OPAMROOT"] = opamroot
    ENV["OPAMYES"] = "1"
    system "opam", "init", "--no-setup"
    system "opam", "install", "ocamlfind"
    system "./configure", "--disable-dependency-tracking",
                          "--enable-release",
                          "--enable-ocaml",
                          "--enable-opt",
                          "--enable-ocaml",
                          "--with-pdflatex=no",
                          "--prefix=#{prefix}"
    system "opam", "config", "exec", "--", "make"
    system "make", "install"

    pkgshare.install "demos/simple.cocci", "demos/simple.c"
  end

  test do
    system "#{bin}/spatch", "-sp_file", "#{pkgshare}/simple.cocci",
                            "#{pkgshare}/simple.c", "-o", "new_simple.c"
    expected = <<~EOS
      int main(int i) {
        f("ca va", 3);
        f(g("ca va pas"), 3);
      }
    EOS
    assert_equal expected, (testpath/"new_simple.c").read
  end
end
