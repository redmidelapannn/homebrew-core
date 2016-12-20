class Ispell < Formula
  desc "International Ispell"
  homepage "https://lasr.cs.ucla.edu/geoff/ispell.html"
  url "https://www.cs.hmc.edu/~geoff/tars/ispell-3.4.00.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/i/ispell/ispell_3.4.00.orig.tar.gz"
  sha256 "5dc42e458635f218032d3ae929528e5587b1e7247564f0e9f9d77d5ccab7aec2"

  bottle do
    rebuild 1
    sha256 "d0fde3a26a5d6f8683e993b9b4effe552e0a17a1049c8f1eb3488def2623bccd" => :sierra
    sha256 "6320e0e45672af25e2c042bcf667460d30e6457b82ebca175847fa90dad71974" => :el_capitan
    sha256 "d6ae29ce61269887224088bec7ad03766cd3ebe6ddf63f7a200146b623ff707e" => :yosemite
  end

  def install
    ENV.deparallelize

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
