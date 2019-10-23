class Tdb < Formula
  desc "Trivial database library"
  homepage "https://tdb.samba.org"
  url "https://www.samba.org/ftp/tdb/tdb-1.4.2.tar.gz"
  sha256 "9040b2cce4028e392f063f91bbe76b8b28fecc2b7c0c6071c67b5eb3168e004a"

  bottle do
    cellar :any
    sha256 "3c4c2b4c34eb61433dba4f2b057cff93fbe3ad71258445ac09243b37990e5daa" => :catalina
    sha256 "d8056c17fa6d4a671d4f3a0a6453897cdc7418172b860ddd99c3ea8ed5f803ec" => :mojave
    sha256 "9ed9d767e0ddc5fbf32f79b11c9c362ef1ff4b632d3a3799b34eeb99f731eec1" => :high_sierra
  end

  depends_on "docbook" => :build
  depends_on "docbook-xsl" => :build
  depends_on "python" => :build

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    system "./configure", "--prefix=#{prefix}", "--disable-rpath"
    system "make", "test"
    system "make", "install"
  end
end
