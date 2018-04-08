class Curlish < Formula
  desc "Curl wrapper that adds support for OAuth 2.0"
  homepage "https://pythonhosted.org/curlish/"
  url "https://github.com/fireteam/curlish/archive/1.22.tar.gz"
  sha256 "6fdd406e6614b03b16be15b7b51568a7a041d2fb631be4e8caa223c0c3a28f00"

  head "https://github.com/fireteam/curlish.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "309de29af5ba9dabcc6328ea24dac5df20dc4ab152b5ac943b10c036540a2f37" => :high_sierra
    sha256 "309de29af5ba9dabcc6328ea24dac5df20dc4ab152b5ac943b10c036540a2f37" => :sierra
    sha256 "309de29af5ba9dabcc6328ea24dac5df20dc4ab152b5ac943b10c036540a2f37" => :el_capitan
  end

  # curlish needs argparse (2.7+)
  depends_on "python@2"

  def install
    bin.install "curlish.py" => "curlish"
  end

  test do
    system "#{bin}/curlish", "https://brew.sh/"
  end
end
