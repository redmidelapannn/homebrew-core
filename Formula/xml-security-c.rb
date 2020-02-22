class XmlSecurityC < Formula
  desc "Implementation of primary security standards for XML"
  homepage "https://santuario.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=santuario/c-library/xml-security-c-2.0.2.tar.bz2"
  mirror "https://archive.apache.org/dist/santuario/c-library/xml-security-c-2.0.2.tar.bz2"
  sha256 "39e963ab4da477b7bda058f06db37228664c68fe68902d86e334614dd06e046b"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "e88f336c233a576cf4a251120f6c8155abf07611f1210ebba2383c6a0715db52" => :catalina
    sha256 "974b8cf2a02ff76e08c85eb72e207e56884a9b36e6d1fe18243df422a4b01f68" => :mojave
    sha256 "90a3188c1b7b518e0714e468557b7a9030bd8d472cbcb6b12b7f786ff7febbe7" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"
  depends_on "xerces-c"

  def install
    ENV.cxx11

    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking",
                          "--with-openssl=#{Formula["openssl@1.1"].opt_prefix}"
    system "make", "install"
  end

  test do
    assert_match /All tests passed/, pipe_output("#{bin}/xsec-xtest 2>&1")
  end
end
