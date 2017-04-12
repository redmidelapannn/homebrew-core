class Sslscan < Formula
  desc "Test SSL/TLS enabled services to discover supported cipher suites."
  homepage "https://github.com/rbsec/sslscan"
  url "https://github.com/rbsec/sslscan/archive/1.11.9-rbsec.tar.gz"
  version "1.11.9"
  sha256 "9417061a8f827b02b2b6457031888b1ae0b299460714ce3d9192432afde3a9cb"
  head "https://github.com/rbsec/sslscan.git"

  bottle do
    cellar :any
    sha256 "ea014cd853498694a0239ebb8c3d39df980e28ca8f95dd24b99602008e2c6272" => :sierra
    sha256 "489b66c54cd07847165c0ecb45a4f0d24cd48bc68fbc0ba483900ab1a288afb5" => :el_capitan
    sha256 "fb6eb5f0270a4d5bdd07380e4bcc7b43fb9bc6e22e4339bdc6bbd27dee569b1c" => :yosemite
  end

  depends_on "openssl"

  def install
    system "make"
    # This regression was fixed upstream, but not in this release.
    # https://github.com/rbsec/sslscan/commit/6e89c0597ebc779ac82
    # Remove the below line on next stable release.
    mkdir_p [bin, man1]
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/sslscan", "google.com"
  end
end
