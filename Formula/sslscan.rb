class Sslscan < Formula
  desc "Test SSL/TLS enabled services to discover supported cipher suites."
  homepage "https://github.com/rbsec/sslscan"
  url "https://github.com/rbsec/sslscan/archive/1.11.8-rbsec.tar.gz"
  version "1.11.8"
  sha256 "1449f8bb45d323b322cb070a74d8dcc57b43ca2dba0560e7a16151efc8b3d911"
  head "https://github.com/rbsec/sslscan.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "4faefdb3b38de7cdc9c701bdbbe4c21aadd188cf40821daaa7c322c705103cdc" => :sierra
    sha256 "528f23a9dc7040530dfb66e88cc9749ff671b96d37e928f5a30ec05bf0eec074" => :el_capitan
    sha256 "640d9aba9a90a6db5581b78b6197e87d2ed7b425899f2a6cea7705fbf45bf6cc" => :yosemite
  end

  option "with-openssl", "Don't statically link OpenSSL"

  depends_on "openssl" => :optional

  resource "openssl" do
    url "https://github.com/openssl/openssl.git",
        :branch => "OpenSSL_1_0_2-stable"
  end

  def install
    if build.with? "openssl"
      system "make"
    else
      (buildpath/"openssl").install resource("openssl")
      ENV.deparallelize do
        system "make", "static"
      end
    end

    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    if build.without? "openssl"
      assert_match "static", shell_output("#{bin}/sslscan --version")
    end
    system "#{bin}/sslscan", "google.com"
  end
end
