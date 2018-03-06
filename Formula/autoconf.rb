class Autoconf < Formula
  desc "Automatic configure script builder"
  homepage "https://www.gnu.org/software/autoconf"
  url "https://ftp.gnu.org/gnu/autoconf/autoconf-2.69.tar.gz"
  mirror "https://ftpmirror.gnu.org/autoconf/autoconf-2.69.tar.gz"
  sha256 "954bd69b391edc12d6a4a51a2dd1476543da5c6bbf05a95b59dc0dd6fd4c2969"

  bottle do
    cellar :any_skip_relocation
    rebuild 5
    sha256 "9156551282159a0363499ef8ffb1028e06d1da91a12cadf0e35d001d7328f1af" => :high_sierra
    sha256 "31d872d6caecf5baa81262df9df57308ef03ad278ece275ae9823d0dafabd38e" => :sierra
    sha256 "d7097de5323873aa24d616feb39711833ab79f72ef5bef04940351d8f83c1ff6" => :el_capitan
  end

  keg_only :provided_until_xcode43

  def install
    ENV["PERL"] = "/usr/bin/env perl"

    # force autoreconf to look for and use our glibtoolize
    inreplace "bin/autoreconf.in", "libtoolize", "glibtoolize"
    # also touch the man page so that it isn't rebuilt
    inreplace "man/autoreconf.1", "libtoolize", "glibtoolize"

    system "./configure", "--prefix=#{prefix}", "--with-lispdir=#{elisp}"
    system "make", "install"

    rm_f info/"standards.info"
  end

  test do
    cp pkgshare/"autotest/autotest.m4", "autotest.m4"
    system bin/"autoconf", "autotest.m4"
  end
end
