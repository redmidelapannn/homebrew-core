class Speexdsp < Formula
  desc "Speex audio processing library"
  homepage "https://github.com/xiph/speexdsp"
  url "https://github.com/xiph/speexdsp/archive/SpeexDSP-1.2rc3.tar.gz"
  sha256 "e8be7482df7c95735e5466efb371bd7f21115f39eb45c20ab7264d39c57b6413"
  revision 1

  bottle do
    cellar :any
    sha256 "6cdc11943286b9f8b6da9af093e35f1a74a3670778467df101dc3b3e9d7c7d5e" => :sierra
    sha256 "7d4a39f9ae4b962cc53b337c7a2e17e405626e4bf4b865f05b5f13aba3f30b76" => :el_capitan
    sha256 "9ffcbe2836040eb8d96779cb10b2a047e13ef6e92367000128ae71397e277789" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "fftw" => :optional

  def install
    ENV.append "LIBS", "-lfftw3f" if build.with? "fftw"
    system "./autogen.sh"
    args = %W[
      --prefix=#{prefix}
      --disable-debug
      --disable-dependency-tracking
      --enable-sse
    ]
    args << "--with-fft=gpl-fftw3" if build.with? "fftw"
    system "./configure", *args
    system "make"
    system "make", "install"
  end
end
