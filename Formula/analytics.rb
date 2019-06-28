class Analytics < Formula
  desc "CLI tool for sending analytics events to segment.com"
  homepage "https://github.com/segmentio/analytics-rust"
  url "https://github.com/segmentio/analytics-rust/archive/0.2.0.tar.gz"
  sha256 "21b2178cf218ec46a07b429c1f17709504d4fcddb53686918f83861263cb69b6"
  head "https://github.com/segmentio/analytics-rust.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "14b985988c2820a65dabe459b5b024db20d3a9876a3702129d7f0687837cbdcf" => :mojave
    sha256 "34cae692cdff9a8cade49778ca7af76aba58d4734f11b550333ead87dd74e483" => :high_sierra
    sha256 "aa77c0ea49cc203541720579b88dc02ce2393254df9d1d544a3a63e18d81d66d" => :sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix,
                               "--path", ".",
                               "--features", "cli"
  end

  test do
    system "#{bin}/analytics", "--help"
  end
end
