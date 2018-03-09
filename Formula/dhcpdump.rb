class Dhcpdump < Formula
  desc "Monitor DHCP traffic for debugging purposes"
  homepage "https://www.mavetju.org/"
  url "https://www.mavetju.org/download/dhcpdump-1.8.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/d/dhcpdump/dhcpdump_1.8.orig.tar.gz"
  sha256 "6d5eb9418162fb738bc56e4c1682ce7f7392dd96e568cc996e44c28de7f77190"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "bca7b8747e256117a11b65d50c025ace9b0238fd49583ea9d2e9f115ab28db62" => :high_sierra
    sha256 "0f79e02ec0b055ed2ca53479a399bb647fab50cdaba8c2b539c6927078200fe3" => :sierra
    sha256 "ea6c78a94e24ba2b2f46eb3a61699d2f09d50eb7c9e0bb9ecf02aad0b6d7b635" => :el_capitan
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
