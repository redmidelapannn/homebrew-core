class Gforth < Formula
  desc "Implementation of the ANS Forth language"
  homepage "https://www.gnu.org/software/gforth/"
  url "https://www.complang.tuwien.ac.at/forth/gforth/gforth-0.7.3.tar.gz"
  sha256 "2f62f2233bf022c23d01c920b1556aa13eab168e3236b13352ac5e9f18542bb0"
  revision 2

  bottle do
    cellar :any
    sha256 "e000e0ff55ee6b9ddf3c907d7e24855a89c68dc6cca03653b289ce52706fba0e" => :catalina
    sha256 "b84e07778e39420b38cfa4f6010cb33f94f0daff3431ef4023c19d82bdba8017" => :mojave
    sha256 "499a5d7e5897a5c7afba0b32b4bdac10ee2acc8d2d08581976bd79d9c99ca03a" => :high_sierra
  end

  depends_on "emacs" => :build
  depends_on "libffi"
  depends_on "libtool"
  depends_on "pcre"

  def install
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version
    cp Dir["#{Formula["libtool"].opt_share}/libtool/*/config.{guess,sub}"], buildpath
    ENV.deparallelize
    system "./configure", "--prefix=#{prefix}"
    system "make", "EMACS=#{Formula["emacs"].opt_bin}/emacs"
    elisp.mkpath
    system "make", "install", "emacssitelispdir=#{elisp}"

    elisp.install "gforth.elc"
  end

  test do
    assert_equal "2 ", shell_output("#{bin}/gforth -e '1 1 + . bye'")
  end
end
