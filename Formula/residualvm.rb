class Residualvm < Formula
  desc "3D graphic adventure game interpreter"
  homepage "https://residualvm.org/"
  url "https://downloads.sourceforge.net/project/residualvm/residualvm/0.2.1/residualvm-0.2.1-sources.tar.bz2"
  sha256 "cd2748a665f80b8c527c6dd35f8435e718d2e10440dca10e7765574c7402d924"
  revision 1
  head "https://github.com/residualvm/residualvm.git"

  bottle do
    rebuild 1
    sha256 "ec27cd8295b8e09255174663976b4b88ab38cdb83bc280837400397bd62cb1ae" => :mojave
    sha256 "a9888e79df1029964265e6e4f6daed4124eb6a11b9e3fa64de8eac0e9c43030b" => :high_sierra
  end

  depends_on "faad2"
  depends_on "flac"
  depends_on "fluid-synth"
  depends_on "freetype"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libvorbis"
  depends_on "mad"
  depends_on "sdl"
  depends_on "theora"

  def install
    system "./configure", "--prefix=#{prefix}", "--enable-release"
    system "make"
    system "make", "install"
    (share+"icons").rmtree
    (share+"pixmaps").rmtree
  end

  test do
    system "#{bin}/residualvm", "-v"
  end
end
