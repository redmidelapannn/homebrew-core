class Speex < Formula
  desc "Audio codec designed for speech"
  homepage "https://speex.org"
  url "http://downloads.us.xiph.org/releases/speex/speex-1.2.0.tar.gz"
  sha256 "eaae8af0ac742dc7d542c9439ac72f1f385ce838392dc849cae4536af9210094"

  bottle do
    cellar :any
    rebuild 1
    sha256 "20d667286403699a805ad04386aeefe267444bb29d499f2fbad2073040df1246" => :sierra
    sha256 "61a785a78991a5663ed69c2f1bc82e319114d95bce5784e735a49a2783d60412" => :el_capitan
    sha256 "fe186f15375408b6967b7177997d63551643f22f7da76094bdb6c06ce8f5896a" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "libogg" => :recommended

  def install
    ENV.deparallelize
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
