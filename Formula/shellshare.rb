class Shellshare < Formula
  desc "LIVE TERMINAL BROADCAST"
  homepage "http://shellshare.net"
  url "https://github.com/arthar360/shellshare/archive/1.0.0.tar.gz"
  sha256 "e14080e5f58f513975f893dce07412097155c38f1798a96e65b78bcf9992d34c"
  bottle do
    cellar :any_skip_relocation
    sha256 "5c14fbacdf855ae79ee749023dce1d1c191778038891a97670d8c8548d7cb05f" => :sierra
    sha256 "5c14fbacdf855ae79ee749023dce1d1c191778038891a97670d8c8548d7cb05f" => :el_capitan
    sha256 "5c14fbacdf855ae79ee749023dce1d1c191778038891a97670d8c8548d7cb05f" => :yosemite
  end

  def install
    bin.install "shellshare"
  end
  test do
  end
end
