class Scummvm < Formula
  desc "Graphic adventure game interpreter"
  homepage "https://www.scummvm.org/"
  url "https://www.scummvm.org/frs/scummvm/2.0.0/scummvm-2.0.0.tar.xz"
  sha256 "9784418d555ba75822d229514a05cf226b8ce1a751eec425432e6b7e128fca60"
  revision 1
  head "https://github.com/scummvm/scummvm.git"

  bottle do
    sha256 "41ebb3a9236361da8a506774b3a9096588c529cdba2611fddcad6530ae8020cf" => :mojave
    sha256 "c48038887517867d4849458ef23b992ac51401ce4c1f01a28addbe712ec9c5a6" => :high_sierra
    sha256 "3fa71e5406207b1819142d25d4ff212923964e75aebe22a152f64756fd036362" => :sierra
  end

  depends_on "faad2"
  depends_on "flac"
  depends_on "fluid-synth"
  depends_on "freetype"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libvorbis"
  depends_on "mad"
  depends_on "sdl2"
  depends_on "theora"

  def install
    system "./configure", "--prefix=#{prefix}", "--enable-release"
    system "make"
    system "make", "install"
    (share+"pixmaps").rmtree
    (share+"icons").rmtree
  end

  test do
    system "#{bin}/scummvm", "-v"
  end
end
