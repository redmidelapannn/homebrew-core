class Brotli < Formula
  desc "Generic-purpose lossless compression algorithm by Google"
  homepage "https://github.com/google/brotli"
  url "https://github.com/google/brotli/archive/v1.0.1.tar.gz"
  sha256 "6870f9c2c63ef58d7da36e5212a3e1358427572f6ac5a8b5a73a815cf3e0c4a6"
  head "https://github.com/google/brotli.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "ef5a88d788d1eac83038ecd7b2c72a47b468277113655dbb47c6f5fbb996b1f8" => :high_sierra
    sha256 "0b3828ccd5514206d9a575353d0ffd6553df8d466bee5c6652ac5d522ff9d9a2" => :el_capitan
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "VERBOSE=1"
    system "ctest", "-V"
    system "make", "install"
  end

  test do
    (testpath/"file.txt").write("Hello, World!")
    system "#{bin}/brotli", "file.txt", "file.txt.br"
    system "#{bin}/brotli", "file.txt.br", "--output=out.txt", "--decompress"
    assert_equal (testpath/"file.txt").read, (testpath/"out.txt").read
  end
end
