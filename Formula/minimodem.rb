class Minimodem < Formula
  desc "General-purpose software audio FSK modem"
  homepage "http://www.whence.com/minimodem/"
  url "http://www.whence.com/minimodem/minimodem-0.24.tar.gz"
  mirror "https://deb.debian.org/debian/pool/main/m/minimodem/minimodem_0.24.orig.tar.gz"
  sha256 "f8cca4db8e3f284d67f843054d6bb4d88a3db5e77b26192410e41e9a06f4378e"

  bottle do
    cellar :any
    rebuild 1
    sha256 "826449157b1893e152f4354432990300113babb32be9c6b2add3f082662b922c" => :mojave
    sha256 "ed128642e1214ac7ab2551446907b57b7c8427600dca6c6b77ae3290dd3a9587" => :high_sierra
    sha256 "aacbb1357e763829dcc17049813ec0dba0e26a6a76cba07b4f9817a4e540e87c" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "fftw"
  depends_on "libsndfile"
  depends_on "pulseaudio"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--without-alsa"
    system "make", "install"
  end

  test do
    system "#{bin}/minimodem", "--benchmarks"
  end
end
