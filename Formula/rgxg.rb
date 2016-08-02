class Rgxg < Formula
  desc "C library and command-line tool to generate (extended) regular expressions"
  homepage "http://rgxg.sourceforge.net"
  url "https://github.com/rgxg/rgxg/releases/download/v0.1/rgxg-0.1.tar.gz"
  sha256 "4adbc128faf87e44ec80d9dfd3b34871c84634c2ae0f9cfaedd16b07d13f9484"

  bottle do
    cellar :any
    revision 1
    sha256 "28ee5fe855f568709499296dfb523f81d661951c62a233f1441e3053e454114b" => :el_capitan
    sha256 "c2c712f2b76b6b55231a2129eec6868133d161f2e0016042f03ac9cab18aa9b6" => :yosemite
    sha256 "78fc1af38f50e838e8858185db4d2ea5182338a9c94cc3b377052514d3383d42" => :mavericks
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/rgxg", "range", "1", "10"
  end
end
