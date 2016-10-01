class Innoextract < Formula
  desc "Tool to unpack installers created by Inno Setup"
  homepage "https://constexpr.org/innoextract/"
  url "https://constexpr.org/innoextract/files/innoextract-1.6.tar.gz"
  sha256 "66463f145fffd4d5883c6b3e2f7b2c2837d6f07095810114e514233a88c1033e"
  revision 1

  head "https://github.com/dscharrer/innoextract.git"

  bottle do
    cellar :any
    sha256 "1010c99de431381c27f7b53de4df52590e0ef7bbba034938dc42865ed21e4161" => :sierra
    sha256 "490c9734eea983ca9def84fa0284f06af79c9231f7c1a096c6b7731d2c71fa03" => :el_capitan
    sha256 "b49a5266c86500ccefcb369688fab71eba6000feef8ccb6f48fc80e9168615d6" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "boost@1.61"
  depends_on "xz"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/innoextract", "--version"
  end
end
