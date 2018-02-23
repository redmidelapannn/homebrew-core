class XmlToolingC < Formula
  desc "Provides a higher level interface to XML processing"
  homepage "https://wiki.shibboleth.net/confluence/display/OpenSAML/XMLTooling-C"
  url "https://shibboleth.net/downloads/c++-opensaml/2.6.1/xmltooling-1.6.3.tar.gz"
  sha256 "dd1216805e9f24eff5cd047f29dd0c27548c6e2e9f426ea1ba930150a88010f9"
  revision 1

  bottle do
    cellar :any
    sha256 "3fe9f645fc71d935adf8c3e8e21d0120cb45c01d6aab044af0d2af8015a84cea" => :high_sierra
    sha256 "d9c689615001c8bb7dc258320cd27efe227b2b8345e32024fa0422192830da70" => :sierra
    sha256 "673c6442f19fa7debfa2b1bcb44c295a1c2ed1f10bffc04debe77b46960bd3a3" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "log4shib"
  depends_on "xerces-c"
  depends_on "xml-security-c"
  depends_on "boost"
  depends_on "openssl"
  depends_on "curl"

  needs :cxx11

  def install
    ENV.O2 # Os breaks the build
    ENV.cxx11

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
