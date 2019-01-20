class ScummvmTools < Formula
  desc "Collection of tools for ScummVM"
  homepage "https://www.scummvm.org/"
  url "https://www.scummvm.org/frs/scummvm-tools/2.0.0/scummvm-tools-2.0.0.tar.xz"
  sha256 "c2042ccdc6faaf745552bac2c00f213da382a7e382baa96343e508fced4451b3"
  revision 1
  head "https://github.com/scummvm/scummvm-tools.git"

  bottle do
    cellar :any
    sha256 "4867d831fe522c27bfb3d1b6c6496636a55ac0f00af5a10df4ba9b027da5308c" => :mojave
    sha256 "2cd0df943d0c5e8a7506f3ecf53d68b77882d120ea407882d34b799581bdee8a" => :high_sierra
    sha256 "6b3d0fb612c980194f4da76cd3abb34d206276735b8d7eb9180eefac69271723" => :sierra
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
