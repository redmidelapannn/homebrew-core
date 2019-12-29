class ScummvmTools < Formula
  desc "Collection of tools for ScummVM"
  homepage "https://www.scummvm.org/"
  url "https://www.scummvm.org/frs/scummvm-tools/2.1.0/scummvm-tools-2.1.0.tar.xz"
  sha256 "cfc62d285d0e304061db72691cdfb8ce4ead868cffb2658b1f1c81934f404665"
  revision 1
  head "https://github.com/scummvm/scummvm-tools.git"

  bottle do
    cellar :any
    sha256 "69eef1f85dd4ff948cb2923daf91fa2d01995b2624ce034b6c69187ba63d93bd" => :mojave
  end

  depends_on "boost"
  depends_on "flac"
  depends_on "freetype"
  depends_on "libpng"
  depends_on "libvorbis"
  depends_on "mad"
  depends_on "wxmac"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/scummvm-tools-cli", "--list"
  end
end
