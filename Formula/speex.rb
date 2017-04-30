class Speex < Formula
  desc "Audio codec designed for speech"
  homepage "https://speex.org"
  url "http://downloads.us.xiph.org/releases/speex/speex-1.2.0.tar.gz"
  sha256 "eaae8af0ac742dc7d542c9439ac72f1f385ce838392dc849cae4536af9210094"
  revision 1

  bottle do
    cellar :any
    sha256 "dbedf8bff3b6297a2179172c4828bf8d7863c83447239e815e0ed3c8a28230b1" => :sierra
    sha256 "e84f7bbe69309cb51d60f47e8dba58ef2db0368ddf603bac3743e1e3751be55d" => :el_capitan
    sha256 "57b272c77c23e6f0a53bcd06359d6f03a0924d3a03511dd23a801b6530bc96cf" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "libogg" => :recommended
  depends_on "fftw" => :optional

  def install
    ENV.deparallelize
    args = %W[
      --prefix=#{prefix}
      --disable-debug
      --disable-dependency-tracking
      --enable-sse
    ]
    args << "--with-fft=gpl-fftw3" if build.with? "fftw"
    system "./configure", *args
    system "make", "install"
  end
end
