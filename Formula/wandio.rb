class Wandio < Formula
  desc "LibWandio I/O performance will be improved by doing any compression"
  homepage "https://research.wand.net.nz/software/libwandio.php"
  url "https://research.wand.net.nz/software/wandio/wandio-1.0.5.tar.gz"
  sha256 "4184ef09322cfa6b685f4f453e86f74723e4e1613e8a0ea88c8538ddaef51547"

  bottle do
    cellar :any
    sha256 "b2f80ac0b72c74b74529e7d9dc8e7a9d5ec130e0405c4a9316993c9df44b4bc1" => :high_sierra
    sha256 "18377dd9738246878e3357ea95e0164e7ec2f66eab9708b662a5961678355873" => :sierra
    sha256 "a05a9f0b56ccb80fd8de1cd2d3921a08599b88bcd9e9770df81a5fddf2163d24" => :el_capitan
  end

  def install
    system "./configure", "--disable-debug",
                          "--with-http",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/wandiocat", "-h"
  end
end
