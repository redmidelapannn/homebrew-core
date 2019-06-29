class Ispell < Formula
  desc "International Ispell"
  homepage "https://lasr.cs.ucla.edu/geoff/ispell.html"
  url "https://www.cs.hmc.edu/~geoff/tars/ispell-3.4.00.tar.gz"
  mirror "https://deb.debian.org/debian/pool/main/i/ispell/ispell_3.4.00.orig.tar.gz"
  sha256 "5dc42e458635f218032d3ae929528e5587b1e7247564f0e9f9d77d5ccab7aec2"

  bottle do
    rebuild 1
    sha256 "b074972f24b8993fc801914aab1d6c092edc96d744eaae091453c6f487ca8ac7" => :mojave
    sha256 "52a963dac3e6f06f4604b3bdfba36f196cdc8937cd1ef79bf80b1d06da8c98bf" => :high_sierra
    sha256 "0588166f6e182249d87b453af81382de796b4be4b195173f1394f713115a5eab" => :sierra
  end

  uses_from_macos "ncurses"

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
