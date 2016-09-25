class Chromaprint < Formula
  desc "Core component of the AcoustID project (Audio fingerprinting)"
  homepage "https://acoustid.org/chromaprint"
  url "https://bitbucket.org/acoustid/chromaprint/downloads/chromaprint-1.3.2.tar.gz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/c/chromaprint/chromaprint_1.3.2.orig.tar.gz"
  sha256 "c3af900d8e7a42afd74315b51b79ebd2e43bc66630b4ba585a54bf3160439652"

  bottle do
    cellar :any
    sha256 "bf0a9f823f3e704f90512dbd5c0eda7e27658efcacdb36510ddccef5cb377c2c" => :sierra
    sha256 "51f854ca44ec011df6132b6e33860d63d8492ca5eee3b50bfdf397f40c758a2c" => :yosemite
  end

  option "without-examples", "Don't build examples (including fpcalc)"

  depends_on "cmake" => :build
  depends_on "ffmpeg" if build.with? "examples"

  def install
    args = std_cmake_args
    args << "-DBUILD_EXAMPLES=ON" if build.with? "examples"
    system "cmake", ".", *args
    system "make", "install"
  end

  test do
    system "#{bin}/fpcalc", test_fixtures("test.mp3") if build.with? "examples"
  end
end
