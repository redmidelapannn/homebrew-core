class JpegTurbo < Formula
  desc "JPEG image codec that aids compression and decompression"
  homepage "http://www.libjpeg-turbo.org/"
  url "https://downloads.sourceforge.net/project/libjpeg-turbo/1.5.1/libjpeg-turbo-1.5.1.tar.gz"
  sha256 "41429d3d253017433f66e3d472b8c7d998491d2f41caa7306b8d9a6f2a2c666c"

  bottle do
    cellar :any
    rebuild 1
    sha256 "061bd9498470b846b2158fd6e6c9fbe041b261098f35c7a21da3acb70e8ad75c" => :sierra
    sha256 "03a9df06257d9d2c184503c640a3d6592ea53bc71adf4ec4fc5f8df30909d7e0" => :el_capitan
    sha256 "311afa916173b376ec85c8c145e6f0789ddc7baeeecaf7af3a8f29672f36094c" => :yosemite
  end

  head do
    url "https://github.com/libjpeg-turbo/libjpeg-turbo.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  keg_only "libjpeg-turbo is not linked to prevent conflicts with the standard libjpeg."

  option "without-test", "Skip build-time checks (Not Recommended)"
  option "with-java", "Generate the Java wrapper"

  depends_on "libtool" => :build
  depends_on "nasm" => :build
  depends_on "java" if build.with? "java"

  def install
    cp Dir["#{Formula["libtool"].opt_share}/libtool/*/config.{guess,sub}"], buildpath
    args = %W[--disable-dependency-tracking --prefix=#{prefix} --with-jpeg8 --mandir=#{man}]

    args << "--with-java" if build.with? "java"

    system "autoreconf", "-fvi" if build.head?
    system "./configure", *args
    system "make"
    system "make", "test" if build.with? "test"
    ENV.j1 # Stops a race condition error: file exists
    system "make", "install"
  end

  test do
    system "#{bin}/jpegtran", "-crop", "1x1",
                              "-transpose", "-perfect",
                              "-outfile", "out.jpg",
                              test_fixtures("test.jpg")
  end
end
