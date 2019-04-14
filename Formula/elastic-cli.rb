class ElasticCli < Formula
  desc "Command-line interface for ElasticSearch"
  homepage "https://github.com/avalarin/elasticsearch-cli"

  url "https://github.com/avalarin/elasticsearch-cli/archive/v0.2.4.tar.gz"
  sha256 "e7107532d41ebadc44c9434c142d53d1823f3b8d3b4d760879a9a525aab4613c"

  head "https://github.com/avalarin/elasticsearch-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b7253f438495dda6a16e5a1532cd9970d35dd5f23aa63941a21b5fe1dd2cc582" => :mojave
    sha256 "e38a33685817555dd3a5bcfe95870ac323b35ad6471f0929b0927f0b61ab43ff" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    assert_match "elastic-cli #{version}", shell_output("#{bin}/elastic-cli -V")
  end
end
