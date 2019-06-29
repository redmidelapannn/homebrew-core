class Analog < Formula
  desc "Logfile analyzer"
  # Last known good original homepage: https://web.archive.org/web/20140822104703/analog.cx/
  homepage "https://tracker.debian.org/pkg/analog"
  url "https://deb.debian.org/debian/pool/main/a/analog/analog_6.0.orig.tar.gz"
  sha256 "31c0e2bedd0968f9d4657db233b20427d8c497be98194daf19d6f859d7f6fcca"
  revision 1

  bottle do
    rebuild 3
    sha256 "7bcb1a91f1ae8ac867d9e02627786073e06d48aaaac8099822abaa84390e805e" => :mojave
    sha256 "0d68ebb220e4ac0dd8f5403376a7ad00127dbc78635db916dd7835fd6eea4334" => :high_sierra
    sha256 "886569061e60193b364916d6255b339ce1b337a6668ba167388a2853ed1f580c" => :sierra
  end

  depends_on "gd"
  depends_on "jpeg"
  depends_on "libpng"
  uses_from_macos "zlib"

  def install
    system "make", "CC=#{ENV.cc}",
                   "CFLAGS=#{ENV.cflags}",
                   "DEFS='-DLANGDIR=\"#{pkgshare}/lang/\"' -DHAVE_ZLIB",
                   "LIBS=-lz",
                   "OS=OSX"

    bin.install "analog"
    pkgshare.install "examples", "how-to", "images", "lang"
    pkgshare.install "analog.cfg" => "analog.cfg-dist"
    (pkgshare/"examples").install "logfile.log"
    man1.install "analog.man" => "analog.1"
  end

  test do
    output = pipe_output("#{bin}/analog #{pkgshare}/examples/logfile.log")
    assert_match /(United Kingdom)/, output
  end
end
