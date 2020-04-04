class Nfdump < Formula
  desc "Tools to collect and process netflow data on the command-line"
  homepage "https://nfdump.sourceforge.io"
  url "https://github.com/phaag/nfdump/archive/v1.6.20.tar.gz"
  sha256 "672f4fbe2b7424cfdba5917441100a440cbc9083f2a79147562fb5a966838543"

  bottle do
    cellar :any
    sha256 "31fc22aeedfe533775d696a93ccc8bccda8256bf793bad588e4de115ba8d03aa" => :catalina
    sha256 "0f1862a7b48aaca689099b1d933852b67ce7dc78f9970b003c90ae2f5a8f7fe7" => :mojave
    sha256 "dc0e10e0cdd0804f6c22d441443e076606e7235808c7d4fb44949d7c0d0efa4d" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}", "--enable-readpcap"
    system "make", "install"
  end

  test do
    system bin/"nfdump", "-Z", "host 8.8.8.8"
  end
end
