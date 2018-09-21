class HttpLoad < Formula
  desc "Test throughput of a web server by running parallel fetches"
  homepage "https://www.acme.com/software/http_load/"
  url "https://www.acme.com/software/http_load/http_load-09Mar2016.tar.gz"
  version "20160309"
  sha256 "5a7b00688680e3fca8726dc836fd3f94f403fde831c71d73d9a1537f215b4587"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "efc4b3048619b840c6db75fa33a53c8043404e58974869c30fa3d09370ee8644" => :mojave
    sha256 "e870146fb3f8aafd8b69926d978de979729fe943935c4af80fc42d1a0b221559" => :high_sierra
    sha256 "67002b716ea25257e877ef0375ca610c13a492972ed98bc4d9fe78ada8f5abf1" => :sierra
    sha256 "d52d52755912d634c514dd07e7ffdc76a0bdbd36b408df91de0a87d5964db7a9" => :el_capitan
  end

  depends_on "openssl"

  def install
    bin.mkpath
    man1.mkpath

    args = %W[
      BINDIR=#{bin}
      LIBDIR=#{lib}
      MANDIR=#{man1}
      CC=#{ENV.cc}
      SSL_TREE=#{Formula["openssl"].opt_prefix}
    ]

    inreplace "Makefile", "#SSL_", "SSL_"
    system "make", "install", *args
  end

  test do
    (testpath/"urls").write "https://brew.sh/"
    system "#{bin}/http_load", "-rate", "1", "-fetches", "1", "urls"
  end
end
