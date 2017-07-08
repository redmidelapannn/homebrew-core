class Speex < Formula
  desc "Audio codec designed for speech"
  homepage "https://speex.org"
  url "http://downloads.xiph.org/releases/speex/speex-1.2.0.tar.gz"
  sha256 "eaae8af0ac742dc7d542c9439ac72f1f385ce838392dc849cae4536af9210094"

  bottle do
    cellar :any
    rebuild 1
    sha256 "ccff8fe60ac54406f34b215bc3c801be1701d1b26e79271aefbd38ccddc97b90" => :sierra
    sha256 "7575703ea5a3c853ff0ed78004b88a11cd442b6eaa76e074bf0e8ba368d41680" => :el_capitan
    sha256 "9992579ffcce08d85f7caede8f681f8137d0deb8b1ab567799d9896355368160" => :yosemite
  end

  option "with-sse", "Build with SSE support"

  depends_on "pkg-config" => :build
  depends_on "libogg" => :recommended
  depends_on "speexdsp" => :optional

  def install
    ENV.deparallelize
    args = %W[
      --prefix=#{prefix}
      --disable-debug
      --disable-dependency-tracking
    ]
    args << "--enable-sse" if build.with? "sse"
    system "./configure", *args
    system "make", "install"
  end
end
