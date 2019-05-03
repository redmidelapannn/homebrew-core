class Dhcpdump < Formula
  desc "Monitor DHCP traffic for debugging purposes"
  homepage "https://www.mavetju.org/"
  url "https://www.mavetju.org/download/dhcpdump-1.8.tar.gz"
  mirror "https://deb.debian.org/debian/pool/main/d/dhcpdump/dhcpdump_1.8.orig.tar.gz"
  sha256 "6d5eb9418162fb738bc56e4c1682ce7f7392dd96e568cc996e44c28de7f77190"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "603db6cf4e5c7221b9f840c88b0655a09ce403688d807cd7739748abd622d63f" => :mojave
  end

  def install
    system "make"
    bin.install "dhcpdump"
    man8.install "dhcpdump.8"
  end

  test do
    system "#{bin}/dhcpdump", "-h"
  end
end
