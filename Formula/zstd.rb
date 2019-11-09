class Zstd < Formula
  desc "Zstandard is a real-time compression algorithm"
  homepage "https://facebook.github.io/zstd/"
  url "https://github.com/facebook/zstd/releases/download/v1.4.4/zstd-1.4.4.tar.gz"
  sha256 "59ef70ebb757ffe74a7b3fe9c305e2ba3350021a918d168a046c6300aeea9315"

  bottle do
    cellar :any
    sha256 "1152e89abbe5c710a44a3400d96e6abb6013617c16bf75355bf5f3044f7ae09e" => :catalina
    sha256 "4e7a2490558815750aca10108f74e2a2b86df910ecb6d01aea5cd256a6ba3201" => :mojave
    sha256 "594706dea1fd373c999dc26e60b6f909a139862afbdba001b8ebaa28ef8be10a" => :high_sierra
  end

  depends_on "cmake" => :build

  def install
    system "make", "install", "PREFIX=#{prefix}/"

    # Build parallel version
    system "make", "-C", "contrib/pzstd", "googletest"
    system "make", "-C", "contrib/pzstd", "PREFIX=#{prefix}"
    bin.install "contrib/pzstd/pzstd"
  end

  test do
    assert_equal "hello\n",
      pipe_output("#{bin}/zstd | #{bin}/zstd -d", "hello\n", 0)

    assert_equal "hello\n",
      pipe_output("#{bin}/pzstd | #{bin}/pzstd -d", "hello\n", 0)
  end
end
