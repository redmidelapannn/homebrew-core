class Chromaprint < Formula
  desc "Core component of the AcoustID project (Audio fingerprinting)"
  homepage "https://acoustid.org/chromaprint"
  url "https://github.com/acoustid/chromaprint/releases/download/v1.4.3/chromaprint-1.4.3.tar.gz"
  sha256 "ea18608b76fb88e0203b7d3e1833fb125ce9bb61efe22c6e169a50c52c457f82"

  bottle do
    rebuild 1
    sha256 "1b84c159ba52a4c46b56bc28a1bbe1943f1c07fa97129b6fe6854881b41331c5" => :high_sierra
    sha256 "6cf4cea7a78f4babc9eb6343d05bbf62c79572f0676526384911be4d9b8817b6" => :sierra
    sha256 "d8ba93754bb1bf5243deabcc5c3e1ee57a1938f683186c9299993aff282cff76" => :el_capitan
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end
  test do
    assert_equal "/usr/local/Cellar/chromaprint/1.4.3/bin/chromaprint", "#{bin}/chromaprint"
  end
end
