class Chromaprint < Formula
  desc "Core component of the AcoustID project (Audio fingerprinting)"
  homepage "https://acoustid.org/chromaprint"
  url "https://github.com/acoustid/chromaprint/releases/download/v1.4.3/chromaprint-1.4.3.tar.gz"
  sha256 "ea18608b76fb88e0203b7d3e1833fb125ce9bb61efe22c6e169a50c52c457f82"
  revision 2

  bottle do
    cellar :any
    sha256 "af9052450023b0c9590a3ec94fe12d26ec3b7c4b6255aec19a89d56197db8d7c" => :catalina
    sha256 "483d31081c472eeffc1b19d028d5c98c3a37f42f894a7cbf64556d97a1cdf31c" => :mojave
    sha256 "68b97d61327e81813a55d29b4873a58dcf53bac7203ce1dce721bfe629d2aa68" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "ffmpeg"

  def install
    system "cmake", "-DCMAKE_BUILD_TYPE=Release", "-DBUILD_TOOLS=ON", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    out = shell_output("#{bin}/fpcalc -json -format s16le -rate 44100 -channels 2 -length 10 /dev/zero")
    assert_equal "AQAAO0mUaEkSRZEGAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA", JSON.parse(out)["fingerprint"]
  end
end
