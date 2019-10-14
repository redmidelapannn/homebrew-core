class ScummvmTools < Formula
  desc "Collection of tools for ScummVM"
  homepage "https://www.scummvm.org/"
  url "https://www.scummvm.org/frs/scummvm-tools/2.0.0/scummvm-tools-2.0.0.tar.xz"
  sha256 "c2042ccdc6faaf745552bac2c00f213da382a7e382baa96343e508fced4451b3"
  revision 1
  head "https://github.com/scummvm/scummvm-tools.git"

  bottle do
    cellar :any
    sha256 "29f13304b960f220fc438b759978258e4de66ad451b049519cc8e697e96f039f" => :catalina
    sha256 "1ab03ae1fafaf4912a6413dcf458aeb5e1f28fac1ad698833186e2d40b3919ea" => :mojave
    sha256 "596229da01ac58df85ac155b5d4105e63b3a9f274b45bb6fad4acce64c9e4ccf" => :high_sierra
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
