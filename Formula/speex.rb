class Speex < Formula
  desc "Audio codec designed for speech"
  homepage "https://speex.org"
  url "http://downloads.us.xiph.org/releases/speex/speex-1.2.0.tar.gz"
  sha256 "eaae8af0ac742dc7d542c9439ac72f1f385ce838392dc849cae4536af9210094"
  revision 1

  bottle do
    cellar :any
    sha256 "8301717de36b8884a14a4c431e2f4bda6b582d08326c82b019e3934cc5d48e67" => :sierra
    sha256 "370dbbf1aff2888f61a997456ed5549cf62eaf1872a20bbd99b7c6a2e02cbae2" => :el_capitan
    sha256 "9f9a160931981fab300082fce78c568a8745db992f8c4c7787bd9892e938b1fd" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "libogg" => :recommended
  depends_on "fftw" => :optional
  depends_on "speexdsp" => :optional

  def install
    ENV.deparallelize
    ENV["SPEEXDSP_CFLAGS"] = "-I#{HOMEBREW_PREFIX}/include/speex" if build.with? "speexdsp"
    ENV["SPEEXDSP_LIBS"] = "-L#{HOMEBREW_PREFIX}/lib -lspeexdsp" if build.with? "speexdsp"
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
