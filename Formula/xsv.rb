class Xsv < Formula
  desc "Fast CSV toolkit written in Rust"
  homepage "https://github.com/BurntSushi/xsv"
  url "https://github.com/BurntSushi/xsv/archive/0.13.0.tar.gz"
  sha256 "2b75309b764c9f2f3fdc1dd31eeea5a74498f7da21ae757b3ffd6fd537ec5345"
  head "https://github.com/BurntSushi/xsv.git"

  bottle do
    rebuild 1
    sha256 "8555d578b39dec2e8eac690d76f92ec6e0f6fce9e4b1596dcb9f42e3780eadd7" => :high_sierra
    sha256 "8080cc4500a2bf994367677e0a4777422562467253d2f8270b2c0948130352b1" => :sierra
    sha256 "dd83ff530448a30d13657bb717939a1b5b1adb81a22ddfbd1534732b447225b2" => :el_capitan
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix
  end

  test do
    (testpath/"test.csv").write("first header,second header")
    system "#{bin}/xsv", "stats", "test.csv"
  end
end
