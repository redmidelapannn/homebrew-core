class Innoextract < Formula
  desc "Tool to unpack installers created by Inno Setup"
  homepage "https://constexpr.org/innoextract/"
  url "https://constexpr.org/innoextract/files/innoextract-1.6.tar.gz"
  sha256 "66463f145fffd4d5883c6b3e2f7b2c2837d6f07095810114e514233a88c1033e"
  head "https://github.com/dscharrer/innoextract.git"

  bottle do
    cellar :any
    sha256 "2dcfb2167b578c4d5294f636aaa3a9a49d83eb436f370c1e71e496908285b08c" => :el_capitan
    sha256 "1e6fb6c0385e951cfb660e07d403e834523d6da3990edb924feb265a5a27d4b1" => :yosemite
    sha256 "112e12920822cfbb1dfbea7db804050f3ef6d829ba1407a1b83015074d9cb40d" => :mavericks
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
