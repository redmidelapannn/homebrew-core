#
# Formula for the subcalc tool
#
class Subcalc < Formula
  desc "Subnet calculation and discovery tool"
  homepage "https://github.com/csjayp/subcalc"
  url "https://github.com/csjayp/subcalc/archive/v1.2.tar.gz"
  sha256 "7bc926b22aa75749e1ab5878932887bc1811115703aac646c04c55f39b2809a8"

  bottle do
    cellar :any_skip_relocation
    sha256 "17e73e9dca1bc6a51dfe416c7b2b4275d550e78dc7b998bb300441327ffc26de" => :high_sierra
    sha256 "e357b0bee21343c8baf479df898c235686a91f980ba4986df6a7708b223ce029" => :sierra
    sha256 "573529b493e994da5e4f9b7b6acc4cd4cfef1a766e8516ff2c58d190ae6f02ff" => :el_capitan
  end

  def install
    system "make"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system "#{bin}/subcalc", "inet", "127.0.0.1/24"
  end
end
