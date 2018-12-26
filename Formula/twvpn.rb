class Twvpn < Formula
  desc "Tool to connect to TWVPN at one click"
  homepage "https://twvpn.wangbaiyuan.cn"
  url "https://github.com/geekeren/twvpn/archive/v0.2.tar.gz"
  sha256 "daf185331faa22e25ac1c42f2903c34535ea7b9fc2d9ce2a02a6e71e3b9a6f81"
  bottle do
    cellar :any_skip_relocation
    sha256 "a7afa11a3b924813798738fe66e77df95378a35618aa93461897a87091ba867a" => :mojave
    sha256 "17f72c490782b56f2e3f3ea929afbe0514d402c2c7e263432fe21435d09f9374" => :high_sierra
    sha256 "17f72c490782b56f2e3f3ea929afbe0514d402c2c7e263432fe21435d09f9374" => :sierra
  end

  depends_on "oath-toolkit"
  def install
    bin.install "twvpn"
  end

  test do
    system "#{bin}/twvpn", "--version"
  end
end
