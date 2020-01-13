class Gforth < Formula
  desc "Implementation of the ANS Forth language"
  homepage "https://www.gnu.org/software/gforth/"
  url "https://www.complang.tuwien.ac.at/forth/gforth/gforth-0.7.3.tar.gz"
  sha256 "2f62f2233bf022c23d01c920b1556aa13eab168e3236b13352ac5e9f18542bb0"
  revision 2

  bottle do
    cellar :any
    sha256 "6b3a0fd3ad3db74f22e2f5eeebba2b94f9fe09652624b82fc7f0218b47679ed0" => :mojave
    sha256 "7efff60ab5339a36c6127d506432cb980011bda9f1748ea469019e4e4120eb5f" => :high_sierra
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
