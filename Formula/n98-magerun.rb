class N98Magerun < Formula
  desc "The swiss army knife for Magento developers, sysadmins and devops."
  homepage "http://magerun.net/"
  url "https://files.magerun.net/n98-magerun.phar"
  version "1.0.0"
  sha256 "199dd0d416260c68e691580ffd3f7a448d60f616529aadadcfee584992d6253e"

  bottle do
    cellar :any_skip_relocation
    sha256 "3202daaf00c28401de3fadf3ad26f760a94c796556e48c513d197257f2e45297" => :el_capitan
    sha256 "378cb626799dd3a8c17e8c3e4d3cd8f079047264dcd15d95b3a2079170b1774e" => :yosemite
    sha256 "fb6a9621689810265ea9c4ba8f776c0d29eb16ee1e16330c6df3468f6757df53" => :mavericks
  end

  def install
    bin.install "n98-magerun.phar" => "n98-magerun"
  end

  test do
    system "#{bin}/n98-magerun", "--version"
  end
end
