class Autoconf < Formula
  desc "Automatic configure script builder"
  homepage "https://www.gnu.org/software/autoconf"
  url "https://ftpmirror.gnu.org/autoconf/autoconf-2.69.tar.gz"
  mirror "https://ftp.gnu.org/gnu/autoconf/autoconf-2.69.tar.gz"
  sha256 "954bd69b391edc12d6a4a51a2dd1476543da5c6bbf05a95b59dc0dd6fd4c2969"

  bottle do
    cellar :any_skip_relocation
    revision 5
    sha256 "457a6fb6ebd24aef42c3fbd95c97146a381855b7658c548921570e3a0630590a" => :el_capitan
    sha256 "9497ead7cf9d23caba172134e3213512e309c43ebe525c5207de014c339c3205" => :yosemite
    sha256 "886c686f46391dafe3d84b48e637bc65dcc3aaaa254b946d94755f17e032f984" => :mavericks
  end

  keg_only :provided_until_xcode43

  def install
    ENV["PERL"] = "/usr/bin/perl"

    # force autoreconf to look for and use our glibtoolize
    inreplace "bin/autoreconf.in", "libtoolize", "glibtoolize"
    # also touch the man page so that it isn't rebuilt
    inreplace "man/autoreconf.1", "libtoolize", "glibtoolize"

    system "./configure", "--prefix=#{prefix}",
           "--with-lispdir=#{share}/emacs/site-lisp/autoconf"
    system "make", "install"

    rm_f info/"standards.info"
  end

  test do
    cp "#{pkgshare}/autotest/autotest.m4", "autotest.m4"
    system "#{bin}/autoconf", "autotest.m4"
  end
end
