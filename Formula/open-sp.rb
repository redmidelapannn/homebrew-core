class OpenSp < Formula
  desc "SGML parser"
  homepage "https://openjade.sourceforge.io"
  url "https://downloads.sourceforge.net/project/openjade/opensp/1.5.2/OpenSP-1.5.2.tar.gz"
  sha256 "57f4898498a368918b0d49c826aa434bb5b703d2c3b169beb348016ab25617ce"

  bottle do
    rebuild 4
    sha256 "43914797b8259c09ef6ad058830fbda2a134d900036faeb18894f0669cef7318" => :sierra
    sha256 "f71eadaaabdb264e26872151b0128a223ff3e7bdec27b4d27856d0a912790a47" => :el_capitan
    sha256 "8541d5a9e39d94b05432d562813d741f66ac75fc16dfaa187444e33f3bbd9793" => :yosemite
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--disable-doc-build",
                          "--enable-http",
                          "--enable-default-catalog=#{etc}/sgml/catalog",
                          "--enable-default-search-path=#{HOMEBREW_PREFIX}/share/sgml"
    system "make", "pkgdatadir=#{share}/sgml/opensp", "install"
  end
end
