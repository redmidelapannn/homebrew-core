class Srtp < Formula
  desc "Implementation of the Secure Real-time Transport Protocol"
  homepage "https://github.com/cisco/libsrtp"
  url "https://github.com/cisco/libsrtp/archive/v2.2.0.tar.gz"
  sha256 "44fd7497bce78767e96b54a11bca520adb2ad32effd515f04bce602b60a1a50b"
  head "https://github.com/cisco/libsrtp.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "5cf944a5668f5a6cabbf7bbf63660d2f352a6d1a38ee30c58c1adacde9ae2cd2" => :mojave
    sha256 "71f9b69c948deeab51d5e9d9ac0d92f7869d1b5be367f5d01bad75fbcb38f526" => :high_sierra
    sha256 "a260fb347adfbbe1e9efa13c4952c517253c73f2fb69be248025dc2caed7cc35" => :sierra
  end

  depends_on "pkg-config" => :build

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make", "test"
    system "make", "shared_library"
    system "make", "install" # Can't go in parallel of building the dylib
    libexec.install "test/rtpw"
  end

  test do
    system libexec/"rtpw", "-l"
  end
end
