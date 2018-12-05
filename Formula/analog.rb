class Analog < Formula
  desc "Logfile analyzer"
  # Last known good original homepage: https://web.archive.org/web/20140822104703/analog.cx/
  homepage "https://tracker.debian.org/pkg/analog"
  url "https://deb.debian.org/debian/pool/main/a/analog/analog_6.0.orig.tar.gz"
  sha256 "31c0e2bedd0968f9d4657db233b20427d8c497be98194daf19d6f859d7f6fcca"
  revision 1

  bottle do
    rebuild 3
    sha256 "a8e4beaf04c8b115fd7c3152a1f053c402de52f90647f1ffd9ea4bef65bc9de3" => :mojave
    sha256 "a5347a4e3a0110bb2233654e289e0f139ab2aafe13a435394601f6ddd05faa09" => :high_sierra
    sha256 "62aea6b03be026521f5671489e79026bbafc6a2288c8952bca562dfa03407526" => :sierra
  end

  depends_on "gd"
  depends_on "jpeg"
  depends_on "libpng"

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
