class JpegTurbo < Formula
  desc "JPEG image codec that aids compression and decompression"
  homepage "https://www.libjpeg-turbo.org/"
  url "https://downloads.sourceforge.net/project/libjpeg-turbo/1.5.3/libjpeg-turbo-1.5.3.tar.gz"
  sha256 "b24890e2bb46e12e72a79f7e965f409f4e16466d00e1dd15d93d73ee6b592523"

  bottle do
    cellar :any
    rebuild 1
    sha256 "118cd9669b7517733a9f9cd6693467aceadb470549bd91358c82fa99fa24a636" => :high_sierra
    sha256 "b4f6db8a375a7c1a001d248ca9ecb4deb0fa547b00387ef02a01ac98ede43948" => :sierra
    sha256 "4f505ad6f35a6bed9c3d83bca1fdcf9d6f250deae879d827e9f30447441a4929" => :el_capitan
  end

  devel do
    url "https://github.com/libjpeg-turbo/libjpeg-turbo/archive/1.5.90.tar.gz"
    sha256 "cb948ade92561d8626fd7866a4a7ba3b952f9759ea3dd642927bc687470f60b7"

    depends_on "cmake" => :build
  end

  head do
    url "https://github.com/libjpeg-turbo/libjpeg-turbo.git"

    depends_on "cmake" => :build
  end

  keg_only "libjpeg-turbo is not linked to prevent conflicts with the standard libjpeg"

  option "without-test", "Skip build-time checks (Not Recommended)"

  depends_on "nasm" => :build

  def install
    if build.stable?
      system "./configure", "--disable-dependency-tracking",
                            "--prefix=#{prefix}",
                            "--with-jpeg8"
    else
      system "cmake", ".", "-DWITH_JPEG8=1", *std_cmake_args
    end

    system "make"
    system "make", "test" if build.with? "test"
    system "make", "install"
  end

  test do
    system "#{bin}/jpegtran", "-crop", "1x1", "-transpose", "-perfect",
                              "-outfile", "out.jpg", test_fixtures("test.jpg")
  end
end
