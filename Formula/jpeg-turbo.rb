class JpegTurbo < Formula
  desc "JPEG image codec that aids compression and decompression"
  homepage "https://www.libjpeg-turbo.org/"
  url "https://downloads.sourceforge.net/project/libjpeg-turbo/1.5.1/libjpeg-turbo-1.5.1.tar.gz"
  sha256 "41429d3d253017433f66e3d472b8c7d998491d2f41caa7306b8d9a6f2a2c666c"

  bottle do
    cellar :any
    rebuild 1
    sha256 "9a8978b8fc2e45b5c80d400567bcb2f9ea2cd75c6997ee619bf3a598614ba6d7" => :sierra
    sha256 "6d3784e0c1679104d14eef1e02416dffc3eca936b4c23d5e697c1bd4fe203b2b" => :el_capitan
    sha256 "a3b8fabdf8eed3602e4515d5ddca4358e843bcbbe5dd90a86ccb2a7905575ab4" => :yosemite
  end

  head do
    url "https://github.com/libjpeg-turbo/libjpeg-turbo.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  keg_only "libjpeg-turbo is not linked to prevent conflicts with the standard libjpeg"

  option "without-test", "Skip build-time checks (Not Recommended)"

  depends_on "libtool" => :build
  depends_on "nasm" => :build

  def install
    cp Dir["#{Formula["libtool"].opt_share}/libtool/*/config.{guess,sub}"], buildpath
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-jpeg8
      --mandir=#{man}
    ]

    system "autoreconf", "-fvi" if build.head?
    system "./configure", *args
    system "make"
    system "make", "test" if build.with? "test"
    ENV.deparallelize # Stops a race condition error: file exists
    system "make", "install"
  end

  test do
    system "#{bin}/jpegtran", "-crop", "1x1",
                              "-transpose", "-perfect",
                              "-outfile", "out.jpg",
                              test_fixtures("test.jpg")
  end
end
