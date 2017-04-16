class Curlish < Formula
  desc "Curl wrapper that adds support for OAuth 2.0"
  homepage "https://pythonhosted.org/curlish/"
  url "https://github.com/fireteam/curlish/archive/1.22.tar.gz"
  sha256 "6fdd406e6614b03b16be15b7b51568a7a041d2fb631be4e8caa223c0c3a28f00"

  head "https://github.com/fireteam/curlish.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "460acba545f2f4147a0c88d958c33d1c8f5aca49f443e725bd57b887d19b3aa6" => :sierra
    sha256 "cd43589cae3414f31513cd0b6dc09e88aecce705afd866ca6649ca714613babd" => :el_capitan
    sha256 "cd43589cae3414f31513cd0b6dc09e88aecce705afd866ca6649ca714613babd" => :yosemite
  end

  # curlish needs argparse (2.7+)
  depends_on :python if MacOS.version <= :snow_leopard

  def install
    bin.install "curlish.py" => "curlish"
  end

  test do
    system "#{bin}/curlish", "https://brew.sh/"
  end
end
