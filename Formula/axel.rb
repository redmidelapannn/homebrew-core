class Axel < Formula
  desc "Light UNIX download accelerator"
  homepage "https://github.com/eribertomota/axel"
  url "https://github.com/eribertomota/axel/archive/2.12.tar.gz"
  sha256 "28e7bb26b7be3f56a61b60ef07e15e05ea9a41850b0ed45a0c56d6d2202f4a8b"
  head "https://github.com/eribertomota/axel.git"

  bottle do
    rebuild 1
    sha256 "e3a6ff1220640f1dafd4734cfd2421b245ff99bbdc2dd9a4d06c0796f2062df4" => :sierra
    sha256 "99dec48d72e8b01a4524a202958e976b12abb7f14001daff74266a47254de130" => :el_capitan
    sha256 "2672bd413fe089182d09b21a71eccdf7a5ed005526ab0f06424dcce8542c8599" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext"
  depends_on "openssl@1.1"

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}"
    system "make", "install"
  end

  test do
    filename = (testpath/"axel.tar.gz")
    system bin/"axel", "-o", "axel.tar.gz", stable.url
    filename.verify_checksum stable.checksum
    assert File.exist?("axel.tar.gz")
  end
end
