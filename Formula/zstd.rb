class Zstd < Formula
  desc "Zstandard is a real-time compression algorithm"
  homepage "https://facebook.github.io/zstd/"
  url "https://github.com/facebook/zstd/releases/download/v1.3.6/zstd-1.3.6.tar.gz"
  sha256 "e832a0c01ea033e2df1f346ac6976d8cf8f9db6416151ba4fc2cae2ac3584594"

  bottle do
    cellar :any
    rebuild 1
    sha256 "a42dc7a08d742fa6bf47b5d9e1b8820e08044001130ebb74cd561f13ee131618" => :mojave
    sha256 "00b892d7844e0a14d99a8741f98f74ec7aa08acdd6611450496e5eef459d6d38" => :high_sierra
    sha256 "66d5b389b6435adc14fd9b200a1277b0567b992eeabde7c4d93a6a045630174d" => :sierra
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
