class Shellshare < Formula
  desc "Shellshare broadcasting service"
  homepage "http://shellshare.net"
  url "https://github.com/arthar360/shellshare/archive/1.0.0.tar.gz"
  version "1.0.0"
  sha256 "e14080e5f58f513975f893dce07412097155c38f1798a96e65b78bcf9992d34c"

  def install

        bin.install "shellshare"

  end

  test do
  end
end
