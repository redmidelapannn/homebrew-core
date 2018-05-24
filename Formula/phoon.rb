class Phoon < Formula
  desc "Displays current or specified phase of the moon via ASCII art"
  homepage "https://www.acme.com/software/phoon/"
  url "https://www.acme.com/software/phoon/phoon_14Aug2014.tar.gz"
  version "04A"
  sha256 "bad9b5e37ccaf76a10391cc1fa4aff9654e54814be652b443853706db18ad7c1"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "4ea6f959ed4080378ad11a1180320852034045290bc354c59c966eea7fbc89f4" => :high_sierra
    sha256 "8b163db72ac74b35b99922ca14b9899c682a73dc3b4d21173378a22fde45461c" => :sierra
    sha256 "f16773e6d59682a54eb0c2af74c2afef1ba2a162bf604024be34dbdb959742e5" => :el_capitan
  end

  def install
    system "make"
    bin.install "phoon"
    man1.install "phoon.1"
  end

  test do
    system "#{bin}/phoon"
  end
end
