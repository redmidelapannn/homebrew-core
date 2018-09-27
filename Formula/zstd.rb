class Zstd < Formula
  desc "Zstandard is a real-time compression algorithm"
  homepage "http://zstd.net/"
  url "https://github.com/facebook/zstd/archive/v1.3.5.tar.gz"
  sha256 "d6e1559e4cdb7c4226767d4ddc990bff5f9aab77085ff0d0490c828b025e2eea"

  bottle do
    cellar :any
    rebuild 1
    sha256 "60694fafe617ac4f59a68c25c3758cb24c8caeed7a5d28859e244179d9af4a74" => :mojave
    sha256 "408046cf0cdeeb7ba2f307e9c1105801f3733ac874c618f5f90dbea4067807bd" => :high_sierra
    sha256 "a55dfd264a60c923ffec85e8aeae516b95bd39d15ce943263d16cf3a193354ca" => :sierra
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
