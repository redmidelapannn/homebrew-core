class AutoconfAT264 < Formula
  desc "Automatic configure script builder"
  homepage "https://www.gnu.org/software/autoconf"
  url "https://ftp.gnu.org/gnu/autoconf/autoconf-2.64.tar.gz"
  mirror "https://ftpmirror.gnu.org/autoconf/autoconf-2.64.tar.gz"
  sha256 "a84471733f86ac2c1240a6d28b705b05a6b79c3cca8835c3712efbdf813c5eb6"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "1d35948b6daef2bf2d04c00050d70ec3eb4d3f045ebfc619ee8064ddfce90cb7" => :high_sierra
    sha256 "731168ac6c8d436221ca1f8ac75efa5222e8ca9bd0f1cff9c6b1f0aa46a143de" => :sierra
    sha256 "579378099c4c38cc037496df079047e79486e9dca443f627d05a89609fa07dac" => :el_capitan
  end

  keg_only :provided_until_xcode43

  def install
    ENV["PERL"] = "/usr/bin/perl"

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
