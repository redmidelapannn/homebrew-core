class ScummvmTools < Formula
  desc "Collection of tools for ScummVM"
  homepage "https://www.scummvm.org/"
  url "https://www.scummvm.org/frs/scummvm-tools/2.0.0/scummvm-tools-2.0.0.tar.xz"
  sha256 "c2042ccdc6faaf745552bac2c00f213da382a7e382baa96343e508fced4451b3"
  head "https://github.com/scummvm/scummvm-tools.git"

  bottle do
    rebuild 1
    sha256 "d75e87ef1a9d1ff5f85f3f403a833e3baf22cbd8302c37c9f9d112b2cc8f5d77" => :high_sierra
    sha256 "af69d5eb2bec44c0a7f4407ece49545f89b0ee3d7d789265ebe745bba1d0abfb" => :sierra
    sha256 "be20761f533e8f78397ee90f297ab6282a1396eafe07c8bb6b3d3ad02d302038" => :el_capitan
  end

  depends_on "boost"
  depends_on "flac"
  depends_on "freetype"
  depends_on "libpng"
  depends_on "libvorbis"
  depends_on "mad"
  depends_on "wxmac" => :recommended

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/scummvm-tools-cli", "--list"
  end
end
