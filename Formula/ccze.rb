class Ccze < Formula
  desc "Robust and modular log colorizer"
  homepage "https://packages.debian.org/wheezy/ccze"
  url "https://deb.debian.org/debian/pool/main/c/ccze/ccze_0.2.1.orig.tar.gz"
  sha256 "8263a11183fd356a033b6572958d5a6bb56bfd2dba801ed0bff276cfae528aa3"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "8a1a48000011d4e1b153144cbc965e931e4cf7c82adf98a43cdc05b850b5802b" => :mojave
    sha256 "8848d239418802306ea2908bd35eae7e9aff5375085c5277059eb753b4e50b46" => :high_sierra
    sha256 "2e285773b16e86fa1d9938d15d2c3441438a7da526dcef0822fd24412269966d" => :sierra
  end

  depends_on "pcre"

  def install
    # https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=823334
    inreplace "src/ccze-compat.c", "#if HAVE_SUBOPTARg", "#if HAVE_SUBOPTARG"
    # Allegedly from Debian & fixes compiler errors on old OS X releases.
    # https://github.com/Homebrew/legacy-homebrew/pull/20636
    inreplace "src/Makefile.in", "-Wreturn-type -Wswitch -Wmulticharacter",
                                 "-Wreturn-type -Wswitch"

    system "./configure", "--prefix=#{prefix}",
                          "--with-builtins=all"
    system "make", "install"
    # Strange but true: using --mandir above causes the build to fail!
    share.install prefix/"man"
  end

  test do
    system "#{bin}/ccze", "--help"
  end
end
