class Librsync < Formula
  desc "Library that implements the rsync remote-delta algorithm"
  homepage "https://librsync.github.io/"
  url "https://github.com/librsync/librsync/archive/v2.3.0.tar.gz"
  sha256 "682a90ad2b38555d5427dc55ad171d4191d5955c21137e513751472e2ed322bf"

  bottle do
    sha256 "719f175a68cd25f969dff836beee7dc2aef3bbae065b70ea13b0aa9a75ca8d0c" => :catalina
    sha256 "ab5c031cff43295076524890d8122421b027cca720022efbf0a58e5c663d10c4" => :mojave
    sha256 "6be8927b7912477d7edbe761fec5b8f8f47ac8ba4b2f89643d2c4dd1e6ed56c2" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "popt"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
    man1.install "doc/rdiff.1"
    man3.install "doc/librsync.3"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rdiff -V")
  end
end
