class Libftdi0 < Formula
  desc "Library to talk to FTDI chips"
  homepage "https://www.intra2net.com/en/developer/libftdi"
  url "https://www.intra2net.com/en/developer/libftdi/download/libftdi-0.20.tar.gz"
  sha256 "3176d5b5986438f33f5208e690a8bfe90941be501cc0a72118ce3d338d4b838e"

  bottle do
    cellar :any
    rebuild 3
    sha256 "3716c6d2a7769cad931df178fd9556d3295dfe3432b130223738fd43b3b2dcc2" => :high_sierra
    sha256 "3d236cbc0a8dd9622c8b41934ba73eb67b86a8c56c7d0478e256850b1750bcf8" => :sierra
    sha256 "f335959ce4b735e89f99526cae3e9e648a76972b5657eea5f52358449190b16f" => :el_capitan
  end

  depends_on "libusb-compat"

  conflicts_with "cspice", :because => "both install `simple` binaries"
  conflicts_with "openhmd", :because => "both install `simple` binaries"

  def install
    mkdir "libftdi-build" do
      system "../configure", "--prefix=#{prefix}"
      system "make"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/libftdi-config", "--version"
  end
end
