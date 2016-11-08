class Ispell < Formula
  desc "International Ispell"
  homepage "https://lasr.cs.ucla.edu/geoff/ispell.html"
  url "https://www.cs.hmc.edu/~geoff/tars/ispell-3.4.00.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/i/ispell/ispell_3.4.00.orig.tar.gz"
  sha256 "5dc42e458635f218032d3ae929528e5587b1e7247564f0e9f9d77d5ccab7aec2"

  bottle do
    rebuild 1
    sha256 "a608a6732e8730d8e9feedc6be86d581a8cc7205d75e3a99eb9802a7e5997667" => :sierra
    sha256 "d43c4069584baf884cb24efd1a814ae02bec74bdb03abd0cd0ffea9c02ab13f6" => :el_capitan
    sha256 "631f297cde330714aa416bd8057c98a81f127399671c3abfcc7d367d133d964d" => :yosemite
  end

  def install
    ENV.deparallelize
    ENV.no_optimization

    # No configure script, so do this all manually
    cp "local.h.macos", "local.h"
    chmod 0644, "local.h"
    inreplace "local.h" do |s|
      s.gsub! "/usr/local", prefix
      s.gsub! "/man/man", "/share/man/man"
      s.gsub! "/lib", "/lib/ispell"
    end

    chmod 0644, "correct.c"
    inreplace "correct.c", "getline", "getline_ispell"

    system "make", "config.sh"
    chmod 0644, "config.sh"
    inreplace "config.sh", "/usr/share/dict", "#{share}/dict"

    (lib/"ispell").mkpath
    system "make", "install"
  end

  test do
    assert_equal "BOTHER BOTHE/R BOTH/R",
                 `echo BOTHER | #{bin}/ispell -c`.chomp
  end
end
