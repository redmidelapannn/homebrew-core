class Innoextract < Formula
  desc "Tool to unpack installers created by Inno Setup"
  homepage "https://constexpr.org/innoextract/"
  head "https://github.com/dscharrer/innoextract.git"
  stable do
    url "https://constexpr.org/innoextract/files/innoextract-1.8.tar.gz"
    sha256 "5e78f6295119eeda08a54dcac75306a1a4a40d0cb812ff3cd405e9862c285269"

    # Boost 1.70+ compatibility. Remove with next release. b47f46 is
    # already in master.
    patch do
      url "https://github.com/dscharrer/innoextract/commit/b47f46102bccf1d813ca159230029b0cd820ceff.patch?full_index=1"
      sha256 "92d321d552a65e16ae6df992a653839fb19de79aa77388c651bf57b3c582d546"
    end
  end

  bottle do
    cellar :any
    rebuild 1
    sha256 "9ab79180f67a940da8f0b739e1f576070c0424dd4f4d451620ae9dc057b5e96b" => :catalina
    sha256 "e1226575e1d7837502ed4e17ebaa411f266994adbaa57f82c375cccd829be862" => :mojave
    sha256 "0eef612716ae051c48777e9e549b78439d82e3012253782174e9c8ef43a88770" => :high_sierra
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
