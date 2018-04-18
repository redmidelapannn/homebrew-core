class Innoextract < Formula
  desc "Tool to unpack installers created by Inno Setup"
  homepage "https://constexpr.org/innoextract/"
  url "https://constexpr.org/innoextract/files/innoextract-1.6.tar.gz"
  sha256 "66463f145fffd4d5883c6b3e2f7b2c2837d6f07095810114e514233a88c1033e"
  revision 2
  head "https://github.com/dscharrer/innoextract.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "fb109805e73fe17ff06b773949b7d8f587f26a979bdb130bffeb710e0527b8c1" => :high_sierra
    sha256 "d2639eedfec18bfd7a00e9f77813cb08ef9928c185291cc884bceb9a5b118266" => :sierra
    sha256 "c3f4708b12df621fcea40d7cb04e7da49513abfbdddef06efef6cb295f6fc798" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "xz"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/innoextract", "--version"
  end
end
